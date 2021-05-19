require 'rails_helper'

RSpec.describe SubCategoryProgress, type: :model do
  describe "Associations" do
    it { should belong_to(:startup).without_validating_presence }
    it { should belong_to(:sub_category).without_validating_presence }
  end

  describe "Method 'correct_values_for_current_stage_id'" do
    let!(:accelerator)        { create(:accelerator) }
    let!(:admin)              { create(:admin,  accelerator_id: accelerator.id) }
      let!(:startup)          { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
    let!(:assessment)         { create(:assessment) }
    let!(:assessment_2)       { create(:assessment) }
      let!(:category)         { create(:category, assessment_id: assessment.id) }
      let!(:category_2)       { create(:category, assessment_id: assessment_2.id) }
        let!(:sub_category)   { create(:sub_category, category_id: category.id) }
        let!(:sub_category_2) { create(:sub_category, category_id: category.id) }
        let!(:sub_category_3) { create(:sub_category, category_id: category_2.id) }
          let!(:stage)        { create(:stage, position: 1, sub_category_id: sub_category.id) }
          let!(:stage_2)      { create(:stage, position: 1, sub_category_id: sub_category_3.id) }

    it "check validation of current_stage_id which must exists in stages_ids" do
      params = {
        startup_id: startup.id,
        sub_category_id: sub_category.id,
        current_stage_id: stage.id
      }

      SubCategoryProgress.create(params)

      expect(SubCategoryProgress.count).to eq(1)
    end

    it "validation doesnt allow create progress if current_stage_id doesn't exist in stages_ids" do
      params = {
        startup_id: startup.id,
        sub_category_id: sub_category_2.id,
        current_stage_id: stage.id
      }

      sub_category_progress = SubCategoryProgress.create(params)

      expect(SubCategoryProgress.count).to eq(0)
      expect(sub_category_progress.errors.messages).to eq({:current_stage_id=>["current_stage_id is invalid"]})
    end
  end
end
