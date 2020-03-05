# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    before_action -> { request.session_options[:skip] = true }
    prepend_before_action :require_no_authentication, only: [:create]

    # before_action :configure_sign_in_params, only: [:create]

    # POST /resource/sign_in
    def create
      user = User.find_for_database_authentication(
        email: params[:user][:email]
      )
      if user&.valid_password?(params[:user][:password])
        render json: user.payload
      else
        render json: {
          errors: ['Invalid Username/Password']
        }, status: :unauthorized
      end
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
