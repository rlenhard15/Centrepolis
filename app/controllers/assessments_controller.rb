class AssessmentsController < ApplicationController

  api :GET, 'api/assessments', "List of assessments names"
  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
  === Params
    Params are absent

  === Success response body
  [
    {
      "name": "First_assessment"
    },
    ...
  ]
  DESC

  def index
    @assessments = Assessment.all

    render json: @assessments.to_json(only: :name)
  end
end
