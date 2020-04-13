require 'rails_helper'

RSpec.describe SubCategory, type: :model do
  describe "Associations" do
    it { should belong_to(:category) }
    it { should have_many(:stages).dependent(:destroy) }
    it { should have_many(:sub_category_progresses).dependent(:destroy) }
  end

  describe "Method 'with_stages_progresses'" do
    let!(:admin)            { create(:admin) }
      let!(:customer)       { create(:customer, created_by: admin.id) }
    let!(:assessment)       { create(:assessment) }
      let!(:category)       { create(:category, assessment_id: assessment.id) }
        let!(:sub_category) { create(:sub_category, category_id: category.id) }
          let!(:stage)      { create(:stage, sub_category_id: sub_category.id) }
            let!(:sub_category_progress) { create(:sub_category_progress, sub_category_id: sub_category.id, current_stage_id: stage.id, customer_id: customer.id) }

    it "return stages progress for sub_category" do
      sub_category_with_progress = SubCategory.with_stages_progresses(customer.id).select("sub_categories.*, sub_category_progresses.*").as_json

      recursively_delete_timestamps(sub_category_with_progress)

      expect(sub_category_with_progress).to eq(
        [
          {
            "id"=> sub_category_progress.id,
            "title"=> sub_category.title,
            "category_id"=> sub_category.category_id,
            "customer_id"=> sub_category_progress.customer_id,
            "sub_category_id"=> sub_category_progress.sub_category_id,
            "current_stage_id"=> sub_category_progress.current_stage_id
          }
        ]
      )
    end
  end
end
