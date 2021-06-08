# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController

    api :POST, '/users/password'
    param :user, Hash, required: true do
      param :email, String, desc: 'Email of user', required: true
    end

    description <<-DESC
      NOTE: This message will be received email was successfully sent. In other case there will
      be error message. In email user will have a link with reset token.
      === Request headers
        Accelerator-Id - integer - required
          Example of Accelerator-Id header : 1

      === Success response body
      {
        "message": "Reset instructions sent"
      }

    DESC

    def create
      self.resource = resource_class.send_reset_password_instructions(
        resource_params
      )

      if successfully_sent?(resource)
        render json: { message: 'Reset instructions sent' }
      else
        render json:
          bad_request_params(resource.errors), status: :bad_request
      end
    end

    api :PUT, '/users/password'
    param :reset_password_token, String, desc: 'Reset password token fetched from link in mail', required: true
    param :password, String, desc: 'New password', required: true
    param :password_confirmation, String, desc: 'New password confirmation', required: true
    param :first_name, String, desc: 'First name of user (is not required for change password endpoint)', required: true
    param :last_name, String, desc: 'Last name of user (is not required for change password endpoint)', required: true
    param :phone_number, String, desc: 'Phone number of the user', required: true

    description <<-DESC
      === Request headers
        Accelerator-Id - integer - required
          Example of Accelerator-Id header : 1
      === Success response body
      {
        "auth_token": "Token",
        "user_type": "UserType",
        "user": {
          "id": 49,
          "email": "user@gmail.com",
          "created_by": 1,
          "created_at": "2020-03-20T10:45:02.522Z",
          "updated_at": "2020-03-20T10:46:25.226Z",
          "first_name": "Xu",
          "last_name": "Xian",
          "startup_id": 1,
          "accelerator_id": 1,
          "phone_number": "(186)285-7925"
        }
      }
    DESC

    def update
      resource = resource_class.set_user_by_password_token(update_password_params)
      if resource && valid_accelerator_id(resource)
        resource = resource.reset_password_by_token(update_password_params)
        if resource.errors.empty? && resource.update(update_user_params)
          resource.unlock_access! if unlockable?(resource)
          if Devise.sign_in_after_reset_password
            resource.after_database_authentication
            render json: resource.payload
          end
        else
          render json:
            bad_request_params(resource.errors), status: :bad_request
        end
      else
        render json:
          bad_request_params(resource.errors), status: :bad_request
      end
    end

    private

    def valid_accelerator_id user
      if !user&.super_admin?
        user&.accelerator_id == accelerator_id
      else
        Accelerator.ids.include?(accelerator_id)
      end
    end

    def bad_request_params(details)
      {
        errors: [
          {
            status: '400',
            title: 'Bad Request',
            detail: details,
            code: '100'
          }
        ]
      }
    end

    def update_password_params
      params.permit(
                     :reset_password_token,
                     :password,
                     :password_confirmation
                   )
    end

    def update_user_params
      params.permit(:first_name, :last_name, :phone_number)
    end

    def accelerator_id
      @accelerator_id ||= request.headers['Accelerator-Id'].to_i
    end

  end
end
