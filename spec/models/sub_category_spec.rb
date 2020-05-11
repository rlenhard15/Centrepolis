require 'rails_helper'

RSpec.describe SubCategory, type: :model do
  describe "Associations" do
    it { should belong_to(:category) }
    it { should have_many(:stages).dependent(:destroy) }
    it { should have_many(:sub_category_progresses).dependent(:destroy) }
  end

  describe "Method 'with_stages_progresses'" do
    let!(:admin)                           { create(:admin) }
      let!(:customer)                      { create(:customer, created_by: admin.id) }
      let!(:customer_2)                    { create(:customer, created_by: admin.id) }
      let!(:customer_3)                    { create(:customer, created_by: admin.id) }
    let!(:assessment)                      { create(:assessment) }
      let!(:category)                      { create(:category, assessment_id: assessment.id) }
        let!(:sub_category)                { create(:sub_category, category_id: category.id) }
          let!(:stage)                     { create(:stage, position: 1, sub_category_id: sub_category.id) }
          let!(:stage_2)                   { create(:stage, position: 2, sub_category_id: sub_category.id) }
            let!(:sub_category_progress)   { create(:sub_category_progress, sub_category_id: sub_category.id, current_stage_id: stage.id, customer_id: customer.id) }
            let!(:sub_category_progress_2) { create(:sub_category_progress, sub_category_id: sub_category.id, current_stage_id: stage_2.id, customer_id: customer_3.id) }

    it "return nil for sub_category_progresses if customer hasnt stages progress for sub_category" do
      sub_category_with_progress = SubCategory.with_stages_progresses(customer.id).select("sub_categories.*, sub_category_progresses.current_stage_id, sub_category_progresses.customer_id").as_json

      recursively_delete_timestamps(sub_category_with_progress)

      expect(sub_category_with_progress).to eq(
        [
          {
            "id"=> sub_category.id,
            "title"=> sub_category.title,
            "category_id"=> sub_category.category_id,
            "customer_id"=> sub_category_progress.customer_id,
            "current_stage_id"=> sub_category_progress.current_stage_id
          }
        ]
      )
    end

    it "return nil for sub_category_progresses if customer hasnt stages progress for sub_category" do
      sub_category_with_progress = SubCategory.with_stages_progresses(customer_2.id).select("sub_categories.*, sub_category_progresses.current_stage_id, sub_category_progresses.customer_id").as_json

      recursively_delete_timestamps(sub_category_with_progress)

      expect(sub_category_with_progress).to eq(
        [
          {
            "id"=>sub_category.id,
            "category_id"=> category.id,
            "current_stage_id"=>nil,
            "customer_id"=> nil,
            "title"=> sub_category.title
          }
        ]
      )
    end
  end
end
