module Admins
  class StartupAdminsController < ApplicationController
    api :GET, 'api/startup_admins', "Only SuperAdmin and Admin can see list of the startup_admins and their startup"
    param :page, Integer, desc: "Page for startup_admins iteration (10 items per page)"

    description <<-DESC

    === Request headers
      Only SuperAdmin, Admin can perform this action
        SuperAdmin   - all startup_admins of any accelerator;
        Admin        - all startup_admins of the admins startups;

        Authentication - string - required
          Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
        Accelerator-Id - integer - required
            Example of Accelerator-Id header : 1

    === Success response body
    {
      "current_page": 1,
      "total_pages": 2,
      "startup_admins": [
        {
          "id": 20,
          "email": "startup_admin@gmail.com",
          "created_at": "2021-05-03T09:09:11.536Z",
          "updated_at": "2021-05-03T09:10:44.003Z",
          "first_name": "Maria",
          "last_name": "Lee",
          "accelerator_id": 1,
          "startup_id": 1,
          "phone_number": "123124124",
          "email_notification": true,
          "startup": {
            "id": 1,
            "name": "Name",
            "accelerator_id": 1,
            "created_at": "2021-04-09T19:04:59.356Z",
            "updated_at": "2021-05-24T14:08:22.089Z"
          }
        },
        ...
      ]
    }

    DESC
    def index
      authorize current_user, policy_class: StartupAdminPolicy

      @startup_admins = policy_scope(User).startup_admins.with_name.for_accelerator(user_accelerator_id).page(page_params)

      render json: {
        current_page: @startup_admins.current_page,
        total_pages: @startup_admins.total_pages,
        startup_admins: @startup_admins.as_json(include: :startup)
      }
    end

    private

      def page_params
        params[:page] || 1
      end
  end
end
