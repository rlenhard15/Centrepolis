require 'rails_helper'

RSpec.describe SubCategoriesController, type: :controller do
  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:authorize_user!) }
  it { should use_before_action(:check_startup) }
  it { should use_before_action(:set_sub_category_progress) }
  it { should use_before_action(:set_assessment) }
  it { should use_before_action(:set_assessment_progress) }

  let!(:accelerator)                   { create(:accelerator) }
  let!(:super_admin)                   { create(:super_admin) }
  let!(:admin)                         { create(:admin, accelerator_id: accelerator.id) }
  let!(:admin_2)                       { create(:admin, accelerator_id: accelerator.id) }
    let!(:startup)                     { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
    let!(:members)                     { create_list(:member, 3, startup_id: startup.id, accelerator_id: accelerator.id) }
    let!(:team_lead)                   { create(:team_lead, accelerator_id: accelerator.id, startup_id: startup.id) }
    let!(:startup_2)                   { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin_2.id}]) }
    let!(:team_lead_2)                 { create(:team_lead, accelerator_id: accelerator.id, startup_id: startup_2.id) }
  let!(:assessment)                    { create(:assessment) }
    let!(:category)                    { create(:category, assessment_id: assessment.id) }
      let!(:sub_category)              { create(:sub_category, category_id: category.id) }
        let!(:stage)                   { create(:stage, position: 1, sub_category_id: sub_category.id) }
        let!(:stage_2)                 { create(:stage, position: 2, sub_category_id: sub_category.id) }
          let!(:sub_category_progress) { create(:sub_category_progress, startup_id: startup.id, sub_category_id: sub_category.id, current_stage_id: stage.id) }
          let!(:assessment_progress)   { create(:assessment_progress, startup_id: startup.id, assessment_id: assessment.id, risk_value: 60) }

    let!(:params)   { ActionController::Parameters.new({'assessment_id': assessment.id, 'category_id': category.id, 'id': sub_category.id, current_stage_id: stage.id, startup_id: startup.id}) }
    let!(:params_2) { ActionController::Parameters.new({startup_id: startup_2.id}) }

    before { params.permit! }
    before { params_2.permit! }

    describe "POST update_progress action" do
      let!(:params_3)   { ActionController::Parameters.new({current_stage_id: stage_2.id, risk_value: 100}) }
      let!(:params_4)   { ActionController::Parameters.new({startup_id: startup.id}) }

      before { params_3.permit! }
      before { params_4.permit! }

      it "return error in json with status forbidden if sign in as super_admin" do
        request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
        sign_in super_admin
        post :update_progress, params: params.merge(params_3).merge(params_4)
        expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:forbidden)
      end

      it "return success messege and risk_value i admin authenticated" do
        request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
        sign_in admin
        post :update_progress, params: params.merge(params_3).merge(params_4)
        sub_category_progress.reload
        assessment_progress.reload
        expect(response.body).to eq({ message: "Progress updates successfully", assessment_risk: assessment_progress.risk_value.to_f }.to_json)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(sub_category_progress.current_stage_id).to eq(stage_2.id)
        expect(assessment_progress.risk_value).to eq(100)
        expect(response).to have_http_status(:success)
      end

      it "return error in json with status forbidden if admin try to update progress for startup doesnt belong to the admin" do
        request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
        sign_in admin
        post :update_progress, params: params.merge(params_2)
        expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:forbidden)
      end

      it "return success messege and risk_value for current member" do
        request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
        sign_in members.first
        post :update_progress, params: params.merge(params_3)
        sub_category_progress.reload
        assessment_progress.reload
        expect(response.body).to eq({ message: "Progress updates successfully", assessment_risk: assessment_progress.risk_value.to_f }.to_json)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(sub_category_progress.current_stage_id).to eq(stage_2.id)
        expect(assessment_progress.risk_value).to eq(100)
        expect(response).to have_http_status(:success)
      end

      it "if there is startup_id and customer try to update progress with this id, its only update his progress" do
        request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
        sign_in members.first
        post :update_progress, params: params.merge(params_2).merge(params_3)
        sub_category_progress.reload
        assessment_progress.reload
        expect(response.body).to eq({ message: "Progress updates successfully", assessment_risk: assessment_progress.risk_value.to_f }.to_json)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(sub_category_progress.startup_id).to eq(members.first.startup_id)
        expect(SubCategoryProgress.find_by_startup_id(startup_2.id)).to eq(nil)
        expect(sub_category_progress.current_stage_id).to eq(stage_2.id)
        expect(assessment_progress.risk_value).to eq(100)
        expect(response).to have_http_status(:success)
      end

      it "return success messege and risk_value for current team_lead" do
        request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
        sign_in team_lead
        post :update_progress, params: params.merge(params_3)
        sub_category_progress.reload
        assessment_progress.reload
        expect(response.body).to eq({ message: "Progress updates successfully", assessment_risk: assessment_progress.risk_value.to_f }.to_json)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(sub_category_progress.current_stage_id).to eq(stage_2.id)
        expect(assessment_progress.risk_value).to eq(100)
        expect(response).to have_http_status(:success)
      end

      it "if there is startup_id and team_lead try to update progress with this id, its only update his progress" do
        request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
        sign_in team_lead
        post :update_progress, params: params.merge(params_2).merge(params_3)
        sub_category_progress.reload
        assessment_progress.reload
        expect(response.body).to eq({ message: "Progress updates successfully", assessment_risk: assessment_progress.risk_value.to_f }.to_json)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(sub_category_progress.startup_id).to eq(team_lead.startup_id)
        expect(SubCategoryProgress.find_by_startup_id(team_lead_2.startup_id)).to eq(nil)
        expect(sub_category_progress.current_stage_id).to eq(stage_2.id)
        expect(assessment_progress.risk_value).to eq(100)
        expect(response).to have_http_status(:success)
      end
    end
end
