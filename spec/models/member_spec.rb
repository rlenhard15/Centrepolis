require 'rails_helper'

RSpec.describe Member, type: :model do
  describe "Associations" do
    it { should belong_to(:startup).with_foreign_key('startup_id') }
    it { should have_many(:sub_category_progresses).dependent(:destroy) }
    it { should have_many(:assessment_progresses).dependent(:destroy) }
    it { should have_many(:notifications) }
  end

  describe "callbacks" do
    let!(:accelerator)       { create(:accelerator) }
    let!(:admin)             { create(:admin, accelerator_id: accelerator.id) }
    let!(:startup)           { create(:startup, accelerator_id: accelerator.id) }
      let!(:admins_startups) { create(:admins_startups, accelerator_id: accelerator.id) }
      let!(:member)          { create(:member, startup_id: startup.id, accelerator_id: accelerator.id) }

    it { expect(member).to callback(:send_email).after(:create) }
  end

  describe "Method 'assessments_risk_list'" do
    let!(:accelerator)             { create(:accelerator) }
    let!(:admin)                   { create(:admin, accelerator_id: accelerator.id) }
    let!(:startup)                 { create(:startup, accelerator_id: accelerator.id) }
      let!(:admins_startups)       { create(:admins_startups, accelerator_id: accelerator.id) }
      let!(:member)                { create(:member, startup_id: startup.id, accelerator_id: accelerator.id) }
      let!(:member_2)              { create(:member, startup_id: startup.id, accelerator_id: accelerator.id) }
      let!(:member_3)              { create(:member, startup_id: startup.id, accelerator_id: accelerator.id) }
    let!(:assessments)             { create_list(:assessment, 2) }
      let!(:assessment_progress)   { create(:assessment_progress, member_id: member.id, assessment_id: assessments.first.id) }
      let!(:assessment_progress_2) { create(:assessment_progress, member_id: member_2.id, assessment_id: assessments.last.id) }

    it "return nil of risk_value if member hasnt any progreses" do
      assessment_risk_list = member_3.assessments_risk_list.as_json

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

    it "return list of assessments risk for member" do
      assessment_risk_list = member.assessments_risk_list.as_json

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
