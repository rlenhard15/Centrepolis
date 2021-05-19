require 'rails_helper'

RSpec.describe Assessment, type: :model do
  describe "Associations" do
    it { should have_many(:categories).dependent(:destroy) }
    it { should have_many(:sub_categories).through(:categories) }
    it { should have_many(:assessment_progresses).dependent(:destroy) }
  end

  describe "Method 'with_assessment_progresses'" do
    let!(:accelerator)               { create(:accelerator) }
    let!(:admin)                     { create(:admin, accelerator_id: accelerator.id) }
      let!(:startup)                 { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
        let!(:startup_admin)         { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup.id) }
        let!(:member)                { create(:member, startup_id: startup.id, accelerator_id: accelerator.id) }
    let!(:admin_2)                   { create(:admin, accelerator_id: accelerator.id) }
      let!(:startup_2)               { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin_2.id}]) }
        let!(:startup_admin_2)       { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup_2.id) }
        let!(:member_2)              { create(:member, startup_id: startup_2.id, accelerator_id: accelerator.id) }
    let!(:admin_3)                   { create(:admin, accelerator_id: accelerator.id) }
      let!(:startup_3)               { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin_3.id}]) }
        let!(:startup_admin_3)       { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup_3.id) }
        let!(:member_3)              { create(:member, startup_id: startup_3.id, accelerator_id: accelerator.id) }
    let!(:assessments)               { create_list(:assessment, 2) }
      let!(:assessment_progress_1)   { create(:assessment_progress, startup_id: startup.id, assessment_id: assessments.first.id) }
      let!(:assessment_progress_2)   { create(:assessment_progress, startup_id: startup.id, assessment_id: assessments.last.id) }
      let!(:assessment_progress_3)   { create(:assessment_progress, startup_id: startup_3.id, assessment_id: assessments.last.id) }

    it "return nil for risk value if startup hasnt assessment progress" do
      assessment_with_risk = Assessment.with_assessment_progresses(startup_2.id).as_json

      info = recursively_delete_timestamps(assessment_with_risk)
      expect(info).to eq(
        [
          {
            "id"=> assessments.first.id,
            "name"=> assessments.first.name,
            "risk_value"=> nil
          },
          {
            "id"=> assessments.last.id,
            "name"=> assessments.last.name,
            "risk_value"=> nil
          }
        ]
      )
    end

    it "return assessments with risk_value for customer" do
      assessment_with_risk = Assessment.with_assessment_progresses(startup.id).as_json

      info = recursively_delete_timestamps(assessment_with_risk)

      expect(info).to eq(
        [
          {
            "id"=> assessments.first.id,
            "name"=> assessments.first.name,
            "risk_value"=> "#{(assessment_progress_1.risk_value).to_f}"
          },
          {
            "id"=> assessments.last.id,
            "name"=> assessments.last.name,
            "risk_value"=> "#{(assessment_progress_2.risk_value).to_f}"
          }
        ]
      )
    end
  end

  describe "Method 'description_with_child_models'" do
    let!(:assessment)         { create(:assessment) }
    let!(:assessment_2)       { create(:assessment) }
    let!(:assessment_3)       { create(:assessment) }
      let!(:category)         { create(:category, assessment_id: assessment.id) }
      let!(:category_2)       { create(:category, assessment_id: assessment_3.id) }
        let!(:sub_category)   { create(:sub_category, category_id: category.id) }
        let!(:sub_category_2) { create(:sub_category, category_id: category_2.id) }
          let!(:stage)        { create(:stage, sub_category_id: sub_category.id) }
          let!(:stage_2)      { create(:stage, sub_category_id: sub_category_2.id) }

    it "return empty info about nested description if there arent categories, sub_categories, stages" do
      assessment_with_desc = assessment_2.as_json(methods: :description_with_child_models)

      info = recursively_delete_timestamps(assessment_with_desc)

      expect(info).to eq(
        {
          "id"=> assessment_2.id,
          "name"=> assessment_2.name,
          "description_with_child_models"=>[]
        }
      )
    end

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

  describe "Method 'assessment_risk'" do

    let!(:accelerator)                     { create(:accelerator) }
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
    let!(:assessment_2)                    { create(:assessment) }
      let!(:category)                      { create(:category, assessment_id: assessment.id) }
      let!(:category_2)                    { create(:category, assessment_id: assessment_2.id) }
        let!(:sub_category)                { create(:sub_category, category_id: category.id) }
        let!(:sub_category_2)              { create(:sub_category, category_id: category_2.id) }
          let!(:stage_1)                   { create(:stage, position: 1, sub_category_id: sub_category.id) }
          let!(:stage_2)                   { create(:stage, position: 2, sub_category_id: sub_category.id) }
          let!(:stage_3)                   { create(:stage, position: 1, sub_category_id: sub_category_2.id) }
            let!(:sub_category_progress)   { create(:sub_category_progress, sub_category_id: sub_category.id, current_stage_id: stage_2.id, startup_id: startup.id) }
            let!(:sub_category_progress_2) { create(:sub_category_progress, sub_category_id: sub_category.id, current_stage_id: stage_1.id, startup_id: startup_3.id) }
            let!(:sub_category_progress_3) { create(:sub_category_progress, sub_category_id: sub_category_2.id, current_stage_id: stage_3.id, startup_id: startup_3.id) }

    it "return correct risk value for assessment if customer has progress" do
      expect(assessment.assessment_risk(startup.id)).to eq(100)
      expect(assessment.assessment_risk(startup_3.id)).to eq(50)
    end

    it "return 0.0 of risk_value if customer hasnt progress for assessment" do
      expect(assessment.assessment_risk(startup_2.id)).to eq(0.0)
    end
  end
end
