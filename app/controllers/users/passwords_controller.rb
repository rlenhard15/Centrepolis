# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController

    api :PUT, '/users/password'
    param :reset_password_token, String, desc: 'Reset password token fetched from link in mail', required: true
    param :password, String, desc: 'New password', required: true
    param :password_confirmation, String, desc: 'New password confirmation', required: true

    description <<-DESC
      === Success response body
      {
        "auth_token": "Token",
        "user_type": "Customer",
        "user": {
          "id": 49,
          "email": "customer_example@gmail.com",
          "created_by": 1,
          "created_at": "2020-03-20T10:45:02.522Z",
          "updated_at": "2020-03-20T10:46:25.226Z",
          "first_name": null,
          "last_name": null,
          "company_name": null
        }
      }
    DESC

    def update
      self.resource = resource_class.reset_password_by_token(update_password_params)

      if resource.errors.empty?
        resource.unlock_access! if unlockable?(resource)
        if Devise.sign_in_after_reset_password
          resource.after_database_authentication
          render json: resource.payload
        end
      else
        render json:
          bad_request_params(resource.errors), status: :bad_request
      end
    end

    private

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
      params.permit(:reset_password_token, :password, :password_confirmation)
    end

  end
end
