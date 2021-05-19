module Admins
  class StartupAdminsController < ApplicationController
    api :GET, 'api/startup_admins', "Only SuperAdmin and Admin can see list of the startup_admins and their startup"
    description <<-DESC

    === Request headers
      Only SuperAdmin, Admin can perform this action
        SuperAdmin   - all startup_admins of any accelerator;
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

      render json: policy_scope(User).startup_admins.for_accelerator(user_accelerator_id).as_json(include: :startup)
    end
  end
end
