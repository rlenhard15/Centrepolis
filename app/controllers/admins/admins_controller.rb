module Admins
  class AdminsController < ApplicationController
    before_action :set_admin, only: :destroy

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
        "phone_number": "(186)285-7925",
        "email_notification": true,
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

    api :DELETE, 'api/admins/:id', 'SuperAdmin deletes Admin (admin receives email that his/her account was deleted)'
    param :id, Integer, desc: "id of admin", required: true

    description <<-DESC

    === Request headers
      Only SuperAdmin can perform this action
        Authentication - string - required
          Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
        Accelerator-Id - integer - required
          Example of Accelerator-Id header : 1

    === Success response body
    {
      "message": "Successfully destroyed"
    }

    DESC

    def destroy
      if @admin.destroy
        UsersService::UsersEmailNotification.call(@admin, current_user)
        render json: {
          message: 'Successfully destroyed'
        }, status: :ok
      else
        render json: @admin.errors, status: :unprocessable_entity
      end
    end

    private

      def set_admin
        @admin = Admin.find_by_id(params[:id])
        authorize @admin
      end
  end
end
