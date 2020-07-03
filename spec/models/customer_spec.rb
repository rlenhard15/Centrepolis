require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "Associations" do
    it { should have_many(:sub_category_progresses).dependent(:destroy) }
    it { should belong_to(:admin).with_foreign_key('created_by') }
    it { should have_many(:assessment_progresses).dependent(:destroy) }
    it { should have_many(:tasks).with_foreign_key('user_id') }
    it { should have_many(:notifications) }
  end

  describe "callbacks" do
    let!(:accelerator) { create(:accelerator) }
    let!(:admin)       { create(:admin, accelerator_id: accelerator.id) }
      let!(:customer)  { create(:customer, created_by: admin.id, accelerator_id: accelerator.id) }

    it { expect(customer).to callback(:send_email).after(:create) }
  end

  describe "Method 'assessments_risk_list'" do
    let!(:accelerator)             { create(:accelerator) }
    let!(:admin)                   { create(:admin, accelerator_id: accelerator.id) }
      let!(:customer)              { create(:customer, created_by: admin.id, accelerator_id: accelerator.id) }
      let!(:customer_2)            { create(:customer, created_by: admin.id, accelerator_id: accelerator.id) }
      let!(:customer_3)            { create(:customer, created_by: admin.id, accelerator_id: accelerator.id) }
    let!(:assessments)             { create_list(:assessment, 2) }
      let!(:assessment_progress)   { create(:assessment_progress, customer_id: customer.id, assessment_id: assessments.first.id) }
      let!(:assessment_progress_2) { create(:assessment_progress, customer_id: customer_2.id, assessment_id: assessments.last.id) }

    it "return nil of risk_value if customer hasnt any progreses" do
      assessment_risk_list = customer_3.assessments_risk_list.as_json

      recursively_delete_timestamps(assessment_risk_list)
      expect(assessment_risk_list).to eq(
        [
          {
            "assessment"=> assessments.first.name,
            "risk_value"=> nil
          },
          {
            "assessment"=> assessments.last.name,
            "risk_value"=> nil
          }
        ]
      )
    end

    it "return list of assessments risk for customer" do
      assessment_risk_list = customer.assessments_risk_list.as_json

      recursively_delete_timestamps(assessment_risk_list)

      expect(assessment_risk_list).to eq(
        [
          {
            "assessment"=> assessments.first.name,
            "risk_value"=> "#{(assessment_progress.risk_value).to_f}"
          },
          {
            "assessment"=> assessments.last.name,
            "risk_value"=> nil
          }
        ]
      )
    end
  end
end
