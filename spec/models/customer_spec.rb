require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "Associations" do
    it { should have_many(:sub_category_progresses).dependent(:destroy) }
    it { should belong_to(:admin).with_foreign_key('created_by') }
    it { should have_many(:assessment_progresses).dependent(:destroy) }
  end

  describe "callbacks" do
    let!(:admin)      { create(:admin) }
      let!(:customer) { create(:customer, created_by: admin.id) }

    it { expect(customer).to callback(:send_email).after(:create) }
  end

  describe "Method 'assessments_risk_list'" do
    let!(:admin)                 { create(:admin) }
      let!(:customer)            { create(:customer, created_by: admin.id) }
    let!(:assessments)           { create_list(:assessment, 2) }
      let!(:assessment_progress) { create(:assessment_progress, customer_id: customer.id, assessment_id: assessments.first.id) }

    it "return list of assessments risk for customer" do
      assessment_risk_list = customer.assessments_risk_list.as_json

      recursively_delete_timestamps(assessment_risk_list)

      expect(assessment_risk_list.count).to eq(2)
      expect(assessment_risk_list).to eq(
        [
          {
            "assessment"=> "Test assessment",
            "risk_value"=> "3.812"
          },
          {
            "assessment"=> "Test assessment",
            "risk_value"=> nil
          }
        ]
      )
    end
  end
end
