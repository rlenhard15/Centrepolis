class CategoriesController < ApplicationController
  before_action :set_assessment, only: :index

  api :GET, '/api/assessments/:assessment_id/categories', "List of categories with related records subcategories and stages"
  param :assessment_id, Integer, desc: "id of assessment",  required: true
  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
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
  DESC

  def index
    @categories = @assessment.categories

    render json: @categories.to_json(include: {sub_categories: {include: :stages}})
  end

  private

  def set_assessment
    @assessment = Assessment.find(params[:assessment_id])
  end
end
