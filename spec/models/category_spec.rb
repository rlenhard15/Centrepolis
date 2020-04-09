require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "Associations" do
    it { should belong_to(:assessment) }
    it { should have_many(:sub_categories).dependent(:destroy) }
  end

  describe "Method 'for_assessment'" do
    let!(:assessment)   { create(:assessment) }
    let!(:assessment_1) { create(:assessment) }
      let!(:categories) { create_list(:category, 2, assessment_id: assessment.id)}
      let!(:category_1) { create(:category, assessment_id: assessment_1.id)}

    it "return categories for assessment" do
      categories_list = Category.for_assessment(assessment.id).as_json

      info = recursively_delete_timestamps(categories_list)

      expect(info.count).to eq(2)
      expect(info).to eq(
        [
          {
            "id"=> categories.first.id,
            "title"=> categories.first.title,
            "assessment_id"=> assessment.id
          },
          {
            "id"=> categories.last.id,
            "title"=> categories.last.title,
            "assessment_id"=> assessment.id
          }
        ]
      )
      expect(info.first["assessment_id"]).to eq(assessment.id)
      expect(info.last["assessment_id"]).to_not eq(assessment_1.id)
    end
  end

  describe "Method 'sub_categories_with_statuses'" do
    let!(:admin)                     { create(:admin) }
      let!(:customer)                { create(:customer, created_by: admin.id) }
    let!(:assessment)                    { create(:assessment) }
      let!(:category)                    { create(:category, assessment_id: assessment.id) }
        let!(:sub_categories)            { create_list(:sub_category, 2, category_id: category.id) }
          let!(:stage_1)                 { create(:stage, sub_category_id: sub_categories.first.id) }
          let!(:stage_2)                 { create(:stage, sub_category_id: sub_categories.last.id) }
            let!(:sub_category_progress) { create(:sub_category_progress, sub_category_id: sub_categories.first.id, customer_id: customer.id, current_stage_id: stage_1.id) }

    it "return sub_categories with all and current stages for certain category" do
      sub_categories_list = category.sub_categories_with_statuses(customer.id).as_json

      recursively_delete_timestamps(sub_categories_list[0]["stages"])
      recursively_delete_timestamps(sub_categories_list[1]["stages"])

      expect(sub_categories_list.count).to eq(2)
      expect(sub_categories_list).to eq(
        [
          {
            "sub_category_id"=> sub_categories.first.id,
            "sub_category_title"=> sub_categories.first.title,
            "current_stage_id"=> sub_category_progress.current_stage_id,
            "stages"=> [
              {
                "id"=> stage_1.id,
                "title"=> stage_1.title,
                "position"=> stage_1.position,
                "sub_category_id"=> sub_categories.first.id
              }
            ]
          },
          {
            "sub_category_id"=> sub_categories.last.id,
            "sub_category_title"=> sub_categories.last.title,
            "current_stage_id"=> nil,
            "stages"=> [
              {
                "id"=> stage_2.id,
                "title"=> stage_2.title,
                "position"=> stage_2.position,
                "sub_category_id"=> sub_categories.last.id
              }
            ]
          }
        ]
      )

    end
  end
end
