require 'rails_helper'

RSpec.describe SubCategory, type: :model do
  describe "Associations" do
    it { should belong_to(:category) }
    it { should have_many(:stages).dependent(:destroy) }
    it { should have_many(:sub_category_progresses).dependent(:destroy) }
  end

  describe "Method 'with_stages_progresses'" do
    let!(:accelerator)                     { create(:accelerator) }
    let!(:admin)                           { create(:admin, accelerator_id: accelerator.id) }
    let!(:admin)                           { create(:admin, accelerator_id: accelerator.id) }
      let!(:startup)                       { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
        let!(:startup_admin)               { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup.id) }
        let!(:member)                      { create(:member, startup_id: startup.id, accelerator_id: accelerator.id) }
    let!(:admin_2)                         { create(:admin, accelerator_id: accelerator.id) }
      let!(:startup_2)                     { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin_2.id}]) }
        let!(:startup_admin_2)             { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup_2.id) }
        let!(:member_2)                    { create(:member, startup_id: startup_2.id, accelerator_id: accelerator.id) }
    let!(:admin_3)                         { create(:admin, accelerator_id: accelerator.id) }
      let!(:startup_3)                     { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin_3.id}]) }
        let!(:startup_admin_3)             { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup_3.id) }
        let!(:member_3)                    { create(:member, startup_id: startup_3.id, accelerator_id: accelerator.id) }
    let!(:assessment)                      { create(:assessment) }
      let!(:category)                      { create(:category, assessment_id: assessment.id) }
        let!(:sub_category)                { create(:sub_category, category_id: category.id) }
          let!(:stage)                     { create(:stage, position: 1, sub_category_id: sub_category.id) }
          let!(:stage_2)                   { create(:stage, position: 2, sub_category_id: sub_category.id) }
            let!(:sub_category_progress)   { create(:sub_category_progress, sub_category_id: sub_category.id, current_stage_id: stage.id, startup_id: startup.id) }
            let!(:sub_category_progress_2) { create(:sub_category_progress, sub_category_id: sub_category.id, current_stage_id: stage_2.id, startup_id: startup_3.id) }

    it "return nil for sub_category_progresses if customer hasnt stages progress for sub_category" do
      sub_category_with_progress = SubCategory.with_stages_progresses(startup.id).select("sub_categories.*, sub_category_progresses.current_stage_id, sub_category_progresses.startup_id").as_json

      recursively_delete_timestamps(sub_category_with_progress)

      expect(sub_category_with_progress).to eq(
        [
          {
            "id"=> sub_category.id,
            "title"=> sub_category.title,
            "category_id"=> sub_category.category_id,
            "startup_id"=> sub_category_progress.startup_id,
            "current_stage_id"=> sub_category_progress.current_stage_id
          }
        ]
      )
    end

    it "return nil for sub_category_progresses if customer hasnt stages progress for sub_category" do
      sub_category_with_progress = SubCategory.with_stages_progresses(startup_2.id).select("sub_categories.*, sub_category_progresses.current_stage_id, sub_category_progresses.startup_id").as_json

      recursively_delete_timestamps(sub_category_with_progress)

      expect(sub_category_with_progress).to eq(
        [
          {
            "id"=>sub_category.id,
            "category_id"=> category.id,
            "current_stage_id"=>nil,
            "startup_id"=> nil,
            "title"=> sub_category.title
          }
        ]
      )
    end
  end
end
