require 'rails_helper'

RSpec.describe StartupsController, type: :controller do
  it { should use_before_action(:authenticate_user!) }

  let!(:accelerator)             { create(:accelerator) }
  let!(:accelerator_2)           { create(:accelerator) }
  let!(:super_admin)             { create(:super_admin) }
  let!(:admins)                  { create_list(:admin, 3, accelerator_id: accelerator.id) }
  let!(:admin)                   { create(:admin, accelerator_id: accelerator_2.id) }
  let!(:startup)                 { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.first.id}]) }
  let!(:startups)                { create_list(:startup, 14, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.first.id}]) }
  let!(:startups_2)              { create_list(:startup, 9, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.last.id}]) }
  let!(:startup_admin)           { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup.id) }
  let!(:member)                  { create(:member, startup_id: startup.id, accelerator_id: accelerator.id) }
  let!(:assessment)              { create(:assessment) }
    let!(:assessment_progress)   { create(:assessment_progress, startup_id: startup.id, assessment_id: assessment.id) }
    let!(:assessment_progress_2) { create(:assessment_progress, startup_id: startups_2.first.id, assessment_id: assessment.id) }
    let!(:category)              { create(:category, assessment_id: assessment.id) }
      let!(:sub_category)        { create(:sub_category, category_id: category.id) }
        let!(:stage)             { create(:stage, sub_category_id: sub_category.id) }

  describe 'GET index action' do

    it 'return all startups of the accelerator of current super_admin in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      get :index
      expect(parse_json(response.body)[0][1]).to eq(1)
      expect(parse_json(response.body)[1][1][0]['assessments_risk_list']).to eq(startup.assessments_risk_list.as_json)
      expect(parse_json(response.body)[1][1].count).to eq(10)
      expect(recursively_delete_timestamps(parse_json(response.body)[1][1][1])).to eq(recursively_delete_timestamps(startups.first.as_json(methods: [:assessments_risk_list, :members, :startup_admins])))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return all startups of the current admin in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.last
      get :index
      expect(parse_json(response.body)[0][1]).to eq(1)
      expect(parse_json(response.body)[1][1].count).to eq(9)
      expect(parse_json(response.body)[1][1][0]['assessments_risk_list']).to eq(startups_2.first.assessments_risk_list.as_json)
      expect(recursively_delete_timestamps(parse_json(response.body)[1][1][1])).to eq(recursively_delete_timestamps(startups_2.second.as_json(methods: [:assessments_risk_list, :members, :startup_admins])))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if startup_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      get :index
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return error with status 403 if member authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      get :index
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'POST create action' do
    let!(:params)   { ActionController::Parameters.new({ startup: {name: "New startup", admins_startups_attributes: [{admin_id: admins.first.id}, {admin_id: admins.last.id}] }}) }
    let!(:params_2) { ActionController::Parameters.new({ startup: {name: "New startup", admins_startups_attributes: [{admin_id: admin.id}] }}) }

    before { params.permit! }
    before { params_2.permit! }

    it 'return new startup with admins who assigned to the startup in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      post :create, params: params
      expect(parse_json(response.body)).to eq(parse_json(Startup.last.as_json(methods: :admins_for_startup).to_json))
      expect(Startup.last.admins.count).to eq(2)
      expect(Startup.last.admin_ids).to eq([admins.first.id, admins.last.id])
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    it 'return new startup with assigned to the startup current admin in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      post :create, params: params
      expect(parse_json(response.body)).to eq(parse_json(Startup.last.as_json(methods: :admins_for_startup).to_json))
      expect(Startup.last.admins.count).to eq(1)
      expect(Startup.last.admin_ids).to eq([admins.first.id])
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    it 'return error with status 403 if startup_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      post :create, params: params
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return error with status 403 if member authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      post :create, params: params
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end
end
