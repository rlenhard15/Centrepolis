module Admins
  class AdminsController < ApplicationController
    api :GET, 'api/admins', "Only SuperAdmin can see list of the admins and their startups"
    description <<-DESC

    === Request headers
      Only SuperAdmin can perform this action
        SuperAdmin   - all admins of any accelerator;

        Authentication - string - required
          Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
        Accelerator-Id - integer - required
            Example of Accelerator-Id header : 1

    === Params
      Params are absent

    === Success response body
    [
      {
        "id": 1,
        "email": "admin@gmail.com",
        "created_at": "2021-04-09T18:49:05.376Z",
        "updated_at": "2021-04-09T18:49:05.376Z",
        "first_name": "Admin",
        "last_name": "Adm",
        "accelerator_id": 1,
        "startup_id": null,
        "startups": [
          {
            "id": 1,
            "name": "MSI",
            "accelerator_id": 1,
            "created_at": "2021-04-09T19:04:59.356Z",
            "updated_at": "2021-04-09T19:04:59.356Z"
          },
          ...
        ]
      },
      ...
    ]


    DESC
    def index
      authorize current_user, policy_class: AdminPolicy

      render json: policy_scope(User).admins.for_accelerator(user_accelerator_id).as_json(methods: :startups)
    end

    api :POST, 'api/admins', 'Only SuperAdmin can create account for admin and invite his on email'
    param :user, Hash, required: true do
      param :email, String, desc: 'Unique email for admin', required: true
    end

    description <<-DESC

      === Request headers
        Only SuperAdmin can perform this action
          Authentication - string - required
            Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
          Accelerator-Id - integer - required
            Example of Accelerator-Id header : 1

      === Success response body
      {
        "id": 18,
        "email": "admin@gmail.com",
        "created_at": "2021-04-28T14:21:53.443Z",
        "updated_at": "2021-04-28T14:21:53.443Z",
        "first_name": null,
        "last_name": null,
        "accelerator_id": 1,
        "startup_id": null
      }

    DESC

    def create
      @admin = Admin.new(
        user_params.merge({
          accelerator_id: user_accelerator_id,
          password: user_random_password
        })
      )
      authorize @admin

      if @admin.save
        render json: @admin, status: :created
      else
        render json: @admin.errors, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:email)
    end
  end
end
