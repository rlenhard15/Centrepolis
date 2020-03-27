class CategoriesController < ApplicationController
  before_action :set_assessment, only: :index

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
    if current_user.admin?
      @categories = policy_scope(Category).where(assessment_id: @assessment.id).to_json(include: {sub_categories: {include: :stages}})
    elsif current_user.customer?
      @categories = policy_scope(Category).where(assessment_id: @assessment.id).to_json(include: {sub_categories: {methods: :sub_category_status}})
    end

    render json: @categories
  end

  private

  def set_assessment
    @assessment = Assessment.find(params[:assessment_id])
  end
end
