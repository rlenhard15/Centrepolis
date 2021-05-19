require 'rails_helper'

RSpec.describe Startup, type: :model do
  describe "Associations" do
    it { should have_many(:startup_admins).with_foreign_key('startup_id') }
    it { should have_many(:members).with_foreign_key('startup_id') }
    it { should have_many(:admins_startups).dependent(:destroy) }
    it { should have_many(:admins).through(:admins_startups) }
    it { should have_many(:sub_category_progresses).dependent(:destroy) }
    it { should have_many(:assessment_progresses).dependent(:destroy) }
  end

  let!(:accelerator)          { create(:accelerator) }
  let!(:super_admin)          { create(:super_admin) }
  let!(:admins)               { create_list(:admin, 2, accelerator_id: accelerator.id) }
    let!(:startup)            { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.first.id}, {admin_id: admins.last.id}]) }

  describe "Method 'admins_for_startup'" do
    it "return admins assigned to the startup" do
      admins_info = startup.admins_for_startup.as_json

      recursively_delete_timestamps(admins_info)

      expect(admins_info).to eq(
        [
          {
            "id"=> admins.first.id,
            "email"=> admins.first.email,
            "first_name"=> admins.first.first_name,
            "last_name"=> admins.first.last_name,
            "accelerator_id"=> admins.first.accelerator_id,
            "startup_id"=> admins.first.startup_id
          },
          {
            "id"=> admins.last.id,
            "email"=> admins.last.email,
            "first_name"=> admins.last.first_name,
            "last_name"=> admins.last.last_name,
            "accelerator_id"=> admins.last.accelerator_id,
            "startup_id"=> admins.last.startup_id
          },
        ]
      )
    end
  end

  describe "Method 'assessments_risk_list'" do
    let!(:accelerator)             { create(:accelerator) }
    let!(:admin)                   { create(:admin, accelerator_id: accelerator.id) }
      let!(:startup)               { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
    let!(:admin_2)                 { create(:admin, accelerator_id: accelerator.id) }
      let!(:startup_2)             { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin_2.id}]) }
    let!(:admin_3)                 { create(:admin, accelerator_id: accelerator.id) }
      let!(:startup_3)             { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin_3.id}]) }
    let!(:assessments)             { create_list(:assessment, 2) }
      let!(:assessment_progress)   { create(:assessment_progress, startup_id: startup.id, assessment_id: assessments.first.id) }
      let!(:assessment_progress_2) { create(:assessment_progress, startup_id: startup_2.id, assessment_id: assessments.last.id) }

    it "return nil of risk_value if member hasnt any progreses" do
      assessment_risk_list = startup_3.assessments_risk_list.as_json

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
      assessment_risk_list = startup.assessments_risk_list.as_json

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
