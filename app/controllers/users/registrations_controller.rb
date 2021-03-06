# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action -> { request.session_options[:skip] = true }
    before_action :configure_sign_up_params

    KEYS_FOR_SIGNUP = %i[
      email
      first_name
      last_name
      password
      password_confirmation
    ].freeze

    api :POST, '/users/sign_up', 'SuperAdmin registration'
    param :user, Hash, required: true do
      param :email, String, desc: 'Unique email', required: true
      param :first_name, String, desc: 'First name of user', required: true
      param :last_name, String, desc: 'Last name of user', required: true
      param :password, String, desc: 'Password', required: true
      param :password_confirmation, String, desc: 'Password Confirmation', required: true
    end
    description <<-DESC
      === Success response body
      {
        "auth_token": "Token",
        "user_type": "SuperAdmin",
        "user": {
          "id": 48,
          "email": "super_admin@gmail.com",
          "created_at": "2020-03-02T12:43:28.691Z",
          "updated_at": "2020-03-02T12:43:28.691Z",
          "first_name": "David",
          "last_name": "Smith",
          "accelerator_id": null,
          "company_name": null,
          "created_by": null
        }
      }
    DESC
    def create
      @super_admin = SuperAdmin.new(sign_up_params)
      if @super_admin.save
        render json: @super_admin.payload
      else
        render json:
          bad_request_params(@super_admin.errors), status: :bad_request
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
