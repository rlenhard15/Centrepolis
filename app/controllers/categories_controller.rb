class CategoriesController < ApplicationController

  api :GET, 'api/categories'
  description <<-DESC

  === Request headers
    Authentication - string - required

  === Success response body
  [
    {
      "id": 3,
      "title": "films",
      "created_at": "2020-02-20T15:32:46.379Z",
      "updated_at": "2020-02-20T15:32:46.379Z",
      "sub_categories": [
        {
           "id": 1,
           "title": "science fiction",
           "category_id": 3,
           "created_at": "2020-02-20T15:40:49.793Z",
           "updated_at": "2020-02-20T15:40:49.793Z",
           "stages": [
             {
                "id": 5,
                "title": "first",
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
