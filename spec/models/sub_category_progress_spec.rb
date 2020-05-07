require 'rails_helper'

RSpec.describe SubCategoryProgress, type: :model do
  describe "Associations" do
    it { should belong_to(:customer).without_validating_presence }
    it { should belong_to(:sub_category).without_validating_presence }
  end

  describe "Method 'correct_values_for_current_stage_id'" do
    let!(:admin)              { create(:admin) }
      let!(:customer)         { create(:customer, created_by: admin.id) }
    let!(:assessment)         { create(:assessment) }
      let!(:category)         { create(:category, assessment_id: assessment.id) }
        let!(:sub_category)   { create(:sub_category, category_id: category.id) }
        let!(:sub_category_2) { create(:sub_category, category_id: category.id) }
          let!(:stage)        { create(:stage, sub_category_id: sub_category.id) }

    it "return 1 if current_stage_id exists in stages_ids" do
      params = {
        customer_id: customer.id,
        sub_category_id: sub_category.id,
        current_stage_id: stage.id
      }

      SubCategoryProgress.create(params)

      expect(SubCategoryProgress.count).to eq(1)
    end

    it "return 0 if current_stage_id doesn't exist in stages_ids" do
      params = {
        customer_id: customer.id,
        sub_category_id: sub_category_2.id,
        current_stage_id: stage.id
      }

      sub_category_progress = SubCategoryProgress.create(params)

      expect(SubCategoryProgress.count).to eq(0)
      expect(sub_category_progress.errors.messages).to eq({:current_stage_id=>["current_stage_id is invalid"]})
    end
  end
end
