require 'rails_helper'

RSpec.describe AssessmentsController, type: :controller do
  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:set_startup) }
  it { should use_before_action(:set_assessment) }

  let!(:accelerator)          { create(:accelerator) }
  let!(:accelerator_2)        { create(:accelerator) }
  let!(:super_admin)          { create(:super_admin) }
  let!(:admin)                { create(:admin, accelerator_id: accelerator.id) }
    let!(:startup_1)          { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
  let!(:admin_2)              { create(:admin, accelerator_id: accelerator.id) }
    let!(:startup_2)          { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin_2.id}]) }
    let!(:team_lead)          { create(:team_lead, accelerator_id: accelerator.id, startup_id: startup_1.id) }
    let!(:member)             { create(:member, startup_id: startup_1.id, accelerator_id: accelerator.id) }
    let!(:member_2)           { create(:member, startup_id: startup_2.id, accelerator_id: accelerator.id) }
  let!(:assessments)          { create_list(:assessment, 2) }
    let!(:assessment_progress){ create(:assessment_progress, startup_id: member.startup.id, assessment_id: assessments.first.id) }
    let!(:categories)         { create_list(:category, 2, assessment_id: assessments.first.id) }
      let!(:sub_category_1)   { create(:sub_category, category_id: categories.first.id) }
      let!(:sub_category_2)   { create(:sub_category, category_id: categories.last.id) }

    let!(:params)             { ActionController::Parameters.new({'id': assessments.first.id}) }
    let!(:params_2)           { ActionController::Parameters.new({'startup_id': startup_1.id}) }
    let!(:params_3)           { ActionController::Parameters.new({'startup_id': startup_2.id}) }

    before { params.permit! }
    before { params_2.permit! }
    before { params_3.permit! }

  describe 'GET index action' do
    it 'return all assessments with risk_value for startup in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      get :index, params: params_2
      expect(parse_json(response.body).count).to eq(Assessment.count)
      expect(parse_json(response.body)).to eq(parse_json(Assessment.with_assessment_progresses(startup_1.id).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if super_admin try to get info startup isnt located on current accelerator' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator_2.id}"})
      sign_in super_admin
      get :index, params: params_2
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return all assessments with risk_value for startup in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      get :index, params: params_2
      expect(parse_json(response.body).count).to eq(Assessment.count)
      expect(parse_json(response.body)).to eq(parse_json(Assessment.with_assessment_progresses(startup_1.id).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if startup doesnt belong to admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      get :index, params: params_3
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return all assessments with risk_value for current admin in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in team_lead
      get :index
      expect(parse_json(response.body).count).to eq(Assessment.count)
      expect(parse_json(response.body)).to eq(parse_json(Assessment.with_assessment_progresses(team_lead.startup.id).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return all assessments with risk_value for startup in json format with status success if member authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      get :index
      expect(parse_json(response.body).count).to eq(Assessment.count)
      expect(parse_json(response.body)).to eq(parse_json(Assessment.with_assessment_progresses(member.startup.id).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET show action' do
    it 'return specific assessment with child models in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      get :show, params: params
      expect(parse_json(response.body)).to eq(parse_json(assessments.first.as_json(methods: :description_with_child_models).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return specific assessment with child models in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      get :show, params: params
      expect(parse_json(response.body)).to eq(parse_json(assessments.first.as_json(methods: :description_with_child_models).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return specific assessment with child models in json format with status success if team_lead authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in team_lead
      get :show, params: params
      expect(parse_json(response.body)).to eq(parse_json(assessments.first.as_json(methods: :description_with_child_models).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return specific assessment with child models in json format with status success if member authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      get :show, params: params
      expect(parse_json(response.body)).to eq(parse_json(assessments.first.as_json(methods: :description_with_child_models).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end
  end
end
