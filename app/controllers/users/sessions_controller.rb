# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    before_action -> { request.session_options[:skip] = true }
    prepend_before_action :require_no_authentication, only: [:create]

    # before_action :configure_sign_in_params, only: [:create]

    api :POST, '/users/sign_in', "User login"
    param :user, Hash, required: true do
      param :email, String, desc: 'Email of existing user', required: true
      param :password, String, desc: 'Password', required: true
    end
    description <<-DESC
      === Request headers
        Accelerator-Id - integer - required
          Example of Accelerator-Id header : 1

      === Success response body
      {
        "auth_token": "Token",
        "user_type": "Admin",
        "user": {
          "id": 48,
          "email": "admin_example@gmail.com",
          "created_at": "2020-03-02T12:43:28.691Z",
          "updated_at": "2020-03-02T12:43:28.691Z",
          "first_name": "David",
          "last_name": "Smith",
          "startup_id": null,
          "accelerator_id": 1
        }
      }
    DESC
    def create

      user = User.find_for_database_authentication(
        email: params[:user][:email]
      )
      if user&.valid_password?(params[:user][:password]) && valid_accelerator_id(user)
        render json: user.payload
      else
        render json: {
          errors: ['Invalid Username/Password']
        }, status: :unauthorized
      end
    end

    private

    def valid_accelerator_id(user)
      if !user.super_admin?
        user.accelerator_id == accelerator_id
      else
        true
      end
    end

    def accelerator_id
      @accelerator_id ||= request.headers['Accelerator-Id'].to_i
    end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
  end
end
