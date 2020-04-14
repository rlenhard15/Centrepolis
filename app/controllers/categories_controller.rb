class CategoriesController < ApplicationController
  before_action :set_category, :set_customer, only: :show

  api :GET, '/api/assessments/:assessment_id/categories', "List of categories"
  param :assessment_id, Integer, desc: "id of assessment",  required: true
  description <<-DESC

  === Request headers
    Only admin and customer can perform this action
      Authentication - string - required
        Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

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
  param :customer_id, Integer, desc: "id of customer, required if current_user is admin", required: true

  description <<-DESC

  === Request headers
    Only admin and customer can perform this action
      Authentication - string - required
        Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

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
      sub_categories: @category.sub_categories_with_statuses(@customer_id)
    )
  end

  private

  def set_customer
    raise Pundit::NotAuthorizedError unless @customer_id = current_user.admin? ? (current_user.customers.ids & [params[:customer_id].to_i]).first : current_user.id
  end

  def set_category
    @category = policy_scope(Category).for_assessment(params[:assessment_id]).find(params[:id])
  end
end
