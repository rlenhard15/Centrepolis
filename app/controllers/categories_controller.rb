class CategoriesController < ApplicationController

  api :GET, 'api/categories', "List of categories with related records subcategories and stages"
  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "bearer"(must be in all Authentication header) + "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo3fQ.ChsmjEoBVIuCmQ2gjq3oqx5QBaCviHeiEWtGY1UOvAw"

  === Params
    Params are absent

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
    @categories = Category.all

    render json: @categories.to_json(include: {sub_categories: {include: :stages}})
  end
end
