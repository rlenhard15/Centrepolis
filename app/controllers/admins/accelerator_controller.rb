module Accelerator
  class AcceleratorController < ApplicationController

    api :GET, 'api/accelerators', "Only SuperAdmin can see list of the admins and their startups"
    param :page, Integer, desc: "Page for admins iteration (10 items per page)"

    description <<-DESC

    === Request headers
      Only SuperAdmin can perform this action
        SuperAdmin   - all admins of any accelerator;
      Authentication - string - required
        Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
      Accelerator-Id - integer - required
        Example of Accelerator-Id header : 1

    === Success response body
    {
      "current_page": 1,
      "total_pages": 2,
      "admins": [
        {
          "id": 17,
          "email": "anastasia@gmail.com",
          "created_at": "2021-04-28T13:56:03.929Z",
          "updated_at": "2021-04-28T14:04:39.908Z",
          "first_name": "Nastya",
          "last_name": "Smith",
          "accelerator_id": 1,
          "startup_id": null,
          "phone_number": null,
          "email_notification": true,
          "startups": [
            {
              "id": 64,
              "name": "MSI",
              "accelerator_id": 1,
              "created_at": "2021-05-27T22:53:34.054Z",
              "updated_at": "2021-05-27T22:53:34.054Z"
            },
            ...
          ]
        },
        ...
      ]
    }

    DESC

    def index
      authorize current_user, policy_class: AcceleratorPolicy

      @accelerators = policy_scope(Accelerator)

      render json: {
        current_page: @accelerators.current_page,
        total_pages: @accelerators.total_pages,
        admins: @accelerators.as_json
      }
    end ∫≥≥≥

    private

    def page_params
      params[:page] || 1
    end
  end
end
