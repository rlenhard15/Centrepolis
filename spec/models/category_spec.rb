require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "Associations" do
    it { should belong_to(:assessment) }
    it { should have_many(:sub_categories).dependent(:destroy) }
  end

  describe "Method 'for_assessment'" do
    let!(:assessment)   { create(:assessment) }
    let!(:assessment_1) { create(:assessment) }
    let!(:assessment_2) { create(:assessment) }
      let!(:categories) { create_list(:category, 2, assessment_id: assessment.id) }
      let!(:category_1) { create(:category, assessment_id: assessment_1.id) }

    it "return empty info if there arent categories for current assessment" do
      categories_list = Category.for_assessment(assessment_2.id).as_json

      expect(categories_list).to eq([])
    end

    it "return categories for assessment" do
      categories_list = Category.for_assessment(assessment.id).as_json

      info = recursively_delete_timestamps(categories_list)

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
    end
  end

  describe "Method 'sub_categories_with_statuses'" do
    let!(:accelerator)                     { create(:accelerator) }
    let!(:admin)                           { create(:admin, accelerator_id: accelerator.id) }
      let!(:startup)                       { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
      let!(:startup_1)                     { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
      let!(:startup_2)                     { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
    let!(:assessment)                      { create(:assessment) }
      let!(:category)                      { create(:category, assessment_id: assessment.id) }
      let!(:category_2)                    { create(:category, assessment_id: assessment.id) }
        let!(:sub_category_3)              { create(:sub_category, category_id: category_2.id) }
        let!(:sub_categories)              { create_list(:sub_category, 2, category_id: category.id) }
          let!(:stage_1)                   { create(:stage, position: 1, sub_category_id: sub_categories.first.id) }
          let!(:stage_2)                   { create(:stage, position: 2, sub_category_id: sub_categories.last.id) }
          let!(:stage_3)                   { create(:stage, position: 1, sub_category_id: sub_category_3.id) }
            let!(:sub_category_progress)   { create(:sub_category_progress, sub_category_id: sub_categories.first.id, startup_id: startup.id, current_stage_id: stage_1.id) }
            let!(:sub_category_progress_2) { create(:sub_category_progress, sub_category_id: sub_categories.last.id, startup_id: startup_2.id, current_stage_id: stage_2.id) }


    it "return sub_categories with nil of current_stage_id if customer hasnt progresses" do
      sub_categories_list = category.sub_categories_with_statuses(startup_1.id).as_json

      recursively_delete_timestamps(sub_categories_list[0]["stages"])
      recursively_delete_timestamps(sub_categories_list[1]["stages"])

      expect(sub_categories_list).to eq(
        [
          {
            "sub_category_id"=> sub_categories.first.id,
            "sub_category_title"=> sub_categories.first.title,
            "current_stage_id"=> nil,
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

    it "return sub_categories with all info and current stages for certain category" do
      sub_categories_list = category.sub_categories_with_statuses(startup.id).as_json

      recursively_delete_timestamps(sub_categories_list[0]["stages"])
      recursively_delete_timestamps(sub_categories_list[1]["stages"])

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
