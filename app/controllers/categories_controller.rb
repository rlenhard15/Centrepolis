class CategoriesController < ApplicationController
  before_action :set_assessment
  before_action :set_category, :selected_customer, only: :show

  api :GET, '/api/assessments/:assessment_id/categories', "List of categories with related records subcategories and stages and for customer subcategories with current status"
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
      "title": "Title of category",
      "created_at": "2020-02-20T15:32:46.379Z",
      "updated_at": "2020-02-20T15:32:46.379Z",
      "sub_categories": [
        {
           "id": 1,
           "title": "Title of sub category",
           "category_id": 3,
           "created_at": "2020-02-20T15:40:49.793Z",
           "updated_at": "2020-02-20T15:40:49.793Z",
           "stages": [
             {
                "id": 5,
                "title": "Title of stage",
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
  === Success response body for customer
  [
    {
      "id": 3,
      "title": "Title of category",
      "created_at": "2020-02-20T15:32:46.379Z",
      "updated_at": "2020-03-16T14:12:47.759Z",
      "assessment_id": 1,
      "sub_categories": [
        {
          "id": 2,
          "title": "Title of sub category",
          "category_id": 3,
          "created_at": "2020-02-20T15:41:13.107Z",
          "updated_at": "2020-02-20T15:41:13.107Z",
          "sub_category_status": [
            {
              "current_stage": 3,
              "total_stages": 4
            }
          ]
        },
        ...
      ]
    },
    ...
  ]

  DESC

  def index
    render json: policy_scope(Category).current_assessment(@assessment.id)
  end

  api :GET, 'api/assessments/:id', "Request for a certain assessment and related categories, sub_categories and stages"
  param :id, Integer, desc: "id of assessment",  required: true

  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  [
    [
        {
            "sub_category": {
                "id": 1,
                "title": "science fiction",
                "category_id": 3,
                "created_at": "2020-02-20T15:40:49.793Z",
                "updated_at": "2020-02-20T15:40:49.793Z"
            },
            "stages": [
                {
                    "id": 5,
                    "title": "first",
                    "created_at": "2020-02-20T15:44:10.603Z",
                    "updated_at": "2020-03-25T15:00:03.466Z",
                    "position": 1,
                    "sub_category_id": 1
                },
                ...
            ],
            "current_stage_id": 7
        }
    ],
    ...
  ]

  DESC

  def show
    render json: @category.sub_categories_status(@customer_id)
  end

  private

  def selected_customer
    raise Pundit::NotAuthorizedError unless @customer_id = current_user.admin? ? params[:id_customer] : current_user.id
  end

  def set_category
    @category = policy_scope(Category).current_assessment(@assessment.id).find(params[:id])
  end

  def set_assessment
    @assessment = Assessment.find(params[:assessment_id])
  end
end
