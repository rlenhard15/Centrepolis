class CategoriesController < ApplicationController
  before_action :set_category, :set_startup, only: :show

  api :GET, '/api/assessments/:assessment_id/categories', "List of categories"
  param :assessment_id, Integer, desc: "id of assessment",  required: true
  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
    Accelerator-Id - integer - required
      Example of Accelerator-Id header : 1

  === Success response body for admin
  [
    {
      "id": 3,
      "title": "First category",
      "created_at": "2020-02-20T15:32:46.379Z",
      "updated_at": "2020-03-16T14:12:47.759Z",
      "assessment_id": 1
    },
    ...
  ]

  DESC

  def index
    render json: policy_scope(Category).for_assessment(params[:assessment_id])
  end

  api :GET, '/api/assessments/:assessment_id/categories/:id', "Request for a certain category with sub_categories, stages and current stages"
  param :id, Integer, desc: "id of category", required: true
  param :assessment_id, Integer, desc: "id of assessment", required: true
  param :startup_id, Integer, desc: "id of a startup, required if current_user is SuperAdmin or Admin", required: true

  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
    Accelerator-Id - integer - required
      Example of Accelerator-Id header : 1

  === Success response body
  {
    "id": 6,
    "title": "Category",
    "created_at": "2020-04-01T17:29:50.614Z",
    "updated_at": "2020-04-01T17:29:50.614Z",
    "assessment_id": 4,
    "sub_categories": [
      {
        "sub_category_id": 6,
        "sub_category_title": "Sub category",
        "current_stage_id": 16,
        "stages": [
          {
            "id": 16,
            "title": "Stage",
            "created_at": "2020-04-01T17:29:50.707Z",
            "updated_at": "2020-04-01T17:29:50.707Z",
            "position": 1,
            "sub_category_id": 6
          },
          ...
        ]
      },
      ...
    ]
  }

  DESC

  def show
    render json: @category.as_json.merge(
      sub_categories: @category.sub_categories_with_statuses(@startup_id)
    )
  end

  private

  def set_startup
    raise Pundit::NotAuthorizedError unless @startup_id = startup_id_for_current_user
  end

  def set_category
    @category = policy_scope(Category).for_assessment(params[:assessment_id]).find(params[:id])
  end
end
