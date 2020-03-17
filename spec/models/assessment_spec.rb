require 'rails_helper'

RSpec.describe Assessment, type: :model do
  describe "Associations" do
    it { should have_many(:categories).dependent(:destroy) }
  end

  describe "Method 'description_with_child_models'" do
    let!(:assessment)   { create(:assessment) }
    let!(:category)     { create(:category, assessment_id: assessment.id) }
    let!(:sub_category) { create(:sub_category, category_id: category.id) }
    let!(:stage)        { create(:stage, sub_category_id: sub_category.id) }

    it "return description of assessment with info of child models" do
      assessment_with_desc = assessment.as_json(methods: :description_with_child_models)

      info = recursively_delete_timestamps(assessment_with_desc)

      expect(info).to eq(
        {
          "id"=> assessment.id,
          "name"=> assessment.name,
          "description_with_child_models"=> [
            {
              "id"=> category.id,
              "title"=> category.title,
              "assessment_id"=> assessment.id,
              "sub_categories"=> [
                {
                  "id"=> sub_category.id,
                  "title"=> sub_category.title,
                  "category_id"=> category.id,
                  "stages"=> [
                    {
                      "id"=> stage.id,
                      "title"=> stage.title,
                      "sub_category_id"=> sub_category.id
                    }
                  ]
                }
              ]
            }
          ]
        }
      )
    end
  end
end
