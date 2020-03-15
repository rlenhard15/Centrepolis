class AccessmentsController < ApplicationController

  api :GET, 'api/accessments', "List of accessments names"
  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
  === Params
    Params are absent

  === Success response body
  [
    {
      "name": "First_accessment"
    },
    ...
  ]
  DESC

  def index
    @accessments = Accessment.all

    render json: @accessments.to_json(only: :name)
  end
end
