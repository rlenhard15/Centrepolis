module Admins
  class StartupAdminsController < ApplicationController
    api :GET, 'api/startup_admins', "Only SuperAdmin and Admin can see list of the startup_admins and their startup"
    description <<-DESC

    === Request headers
      Only SuperAdmin, Admin can perform this action
        SuperAdmin   - all startup_admins of the accelerator;
        Admin        - all startup_admins of the admins startups;

        Authentication - string - required
          Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
        Accelerator-Id - integer - required
            Example of Accelerator-Id header : 1

    === Params
      Params are absent

    === Success response body
    [
      {
        "id": 20,
        "email": "startup_admin@gmail.com",
        "created_at": "2021-05-03T09:09:11.536Z",
        "updated_at": "2021-05-03T09:10:44.003Z",
        "first_name": "Maria",
        "last_name": "Lee",
        "accelerator_id": 1,
        "startup_id": 1,
        "startup": {
          "id": 1,
          "name": "MSI",
          "accelerator_id": 1,
          "created_at": "2021-04-09T19:04:59.356Z",
          "updated_at": "2021-04-09T19:04:59.356Z"
        }
      },
      ...
    ]

    DESC
    def index
      authorize current_user, policy_class: StartupAdminPolicy

      render json: policy_scope(User).startup_admins.as_json(include: :startup)
    end

    api :POST, 'api/startup_admins', 'Only Admin can create account for startup_admin and invite his on email'
    param :user, Hash, required: true do
      param :email, String, desc: 'Unique email for startup_admin', required: true
      param :startup_id, String, desc: 'Startup ID', required: true
    end

    description <<-DESC

      === Request headers
        Only Admin can perform this action
          Authentication - string - required
            Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
          Accelerator-Id - integer - required
            Example of Accelerator-Id header : 1

      === Success response body
      {
        "id": 20,
        "email": "startup_admin@gmail.com",
        "created_at": "2021-05-03T09:09:11.536Z",
        "updated_at": "2021-05-03T09:09:11.536Z",
        "first_name": null,
        "last_name": null,
        "accelerator_id": 1,
        "startup_id": 1
      }

    DESC

    def create
      @startup_admin = StartupAdmin.new(
        user_params.merge({
          accelerator_id: current_user.accelerator_id,
          password: user_random_password
        })
      )
      authorize @startup_admin

      if @startup_admin.save
        render json: @startup_admin, status: :created
      else
        render json: @startup_admin.errors, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :startup_id)
    end
  end
end
