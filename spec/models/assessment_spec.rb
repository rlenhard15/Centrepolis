require 'rails_helper'

RSpec.describe Assessment, type: :model do
  describe "Associations" do
    it { should have_many(:categories).dependent(:destroy) }
    it { should have_many(:sub_categories).through(:categories) }
    it { should have_many(:assessment_progresses).dependent(:destroy) }
  end

  describe "Method 'with_assessment_progresses'" do
    let!(:admin)                     { create(:admin) }
      let!(:customer)                { create(:customer, created_by: admin.id) }
    let!(:assessment)               { create(:assessment) }
      let!(:assessment_progress_1)   { create(:assessment_progress, customer_id: customer.id, assessment_id: assessment.id, risk_value: 3.812) }

    it "return assessments with risk_value for customer" do
      # assessment_with_risk = Assessment.with_assessment_progresses(customer.id)
       byebug

      expect(assessment_with_risk.length).to eq(1)
      expect(Assessment.with_assessment_progresses(customer.id)).to eq(
        [
          {
            "id"=> assessment.id,
            "name"=> assessment.name,
            "created_at"=> assessment.created_at,
            "updated_at"=> assessment.updated_at,
            "risk_value"=> assessment_progress_1.risk_value
          }
        ]
      )

    end
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
                      "sub_category_id"=> sub_category.id,
                      "position"=> stage.position
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
