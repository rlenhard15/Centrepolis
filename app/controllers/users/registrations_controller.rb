# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action -> { request.session_options[:skip] = true }
    before_action :configure_sign_up_params

    KEYS_FOR_SIGNUP = %i[
      email
      password
      password_confirmation
    ].freeze

    api :POST, '/users/admin_sign_up', 'Admin registration'
    param :user, Hash, required: true do
      param :email, String, desc: 'Unique email ', required: true
      param :password, String, desc: 'Password', required: true
      param :password_confirmation, String, desc: 'Password Confirmation', required: true
    end
    description <<-DESC
      === Success response body
      {
        "auth_token": "Token",
        "user_type": "Admin",
        "user": {
          "id": 48,
          "email": "admin_example@gmail.com",
          "created_at": "2020-03-02T12:43:28.691Z",
          "updated_at": "2020-03-02T12:43:28.691Z",
          "first_name": null,
          "last_name": null,
          "company_name": null,
          "created_by": null
        }
      }
    DESC
    def create
      @admin = Admin.new(sign_up_params)
      if @admin.save
        render json: @admin.payload
      else
        render json:
          bad_request_params(@admin.errors), status: :bad_request
      end
    end

    protected

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

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up,
                                        keys: KEYS_FOR_SIGNUP)
    end

  end
end
