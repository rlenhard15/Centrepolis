class AssessmentsController < ApplicationController
  before_action :set_customer, only: :index
  before_action :set_assessment, only: :show

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
      "id": 4,
      "name": "CRL (Commercial Readiness Level)",
      "created_at": "2020-04-01T17:29:50.528Z",
      "updated_at": "2020-04-01T17:29:50.528Z",
      "risk_value": "3.92156862745098"
    },
    ...
  ]
  DESC

  def index
    @assessments = policy_scope(Assessment)

    render json: @assessments.with_assessment_progresses(@customer_id)
  end

  api :GET, 'api/assessments/:id', "Request for a certain assessment and related categories, sub_categories and stages"
  param :id, Integer, desc: "id of assessment",  required: true

  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  {
    "id": 1,
    "name": "First assessment",
    "created_at": "2020-03-14T20:13:27.006Z",
    "updated_at": "2020-03-14T20:13:27.006Z",
    "description": [
      {
        "id": 3,
        "title": "First category",
        "created_at": "2020-02-20T15:32:46.379Z",
        "updated_at": "2020-03-14T20:16:11.530Z",
        "accessment_id": 1,
        "sub_categories": [
          {
            "id": 1,
            "title": "First sub_category",
            "category_id": 3,
            "created_at": "2020-02-20T15:40:49.793Z",
            "updated_at": "2020-02-20T15:40:49.793Z",
            "stages": [
              {
                "id": 5,
                "title": "First stage",
                "sub_category_id": 1,
                "created_at": "2020-02-20T15:44:10.603Z",
                "updated_at": "2020-02-20T15:44:10.603Z"
              },
              ...
            ]
          },
          ...
        ]
      },
      ...
    ]
  }

  DESC

  def show
    render json: @assessment.as_json(methods: :description_with_child_models)
  end

  private

  def set_customer
    raise Pundit::NotAuthorizedError unless @customer_id = current_user.admin? ? (current_user.customers.ids & [params[:customer_id].to_i]).first : current_user.id
  end

  def set_assessment
    @assessment = Assessment.find(params[:id])
  end
end
