require 'rails_helper'

RSpec.describe StartupsController, type: :controller do
  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:set_startup) }

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
    let!(:params_3) { ActionController::Parameters.new({ startup: {name: "New startup"}})}

    before { params.permit! }
    before { params_2.permit! }
    before { params_3.permit! }

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
      post :create, params: params_3
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

  describe 'GET show action' do
    let!(:params_1) { ActionController::Parameters.new({'id': startup.id}) }
    let!(:params_2) { ActionController::Parameters.new({'id': startups.first.id}) }
    let!(:params_3) { ActionController::Parameters.new({'id': startups_2.first.id}) }

    before { params_1.permit! }
    before { params_2.permit! }
    before { params_3.permit! }

    it 'return specific startup in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      get :show, params: params_1
      expect(parse_json(response.body)).to eq(parse_json(startup.as_json(methods: [:assessments_risk_list, :members, :startup_admins]).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if super_admin try to request startup that doesnt belong to the current accelerator' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator_2.id}"})
      sign_in super_admin
      get :show, params: params_1
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return specific startup in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      get :show, params: params_1
      expect(parse_json(response.body)).to eq(parse_json(startup.as_json(methods: [:assessments_risk_list, :members, :startup_admins]).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if admin try to request startup that doesnt belong to the admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      get :show, params: params_3
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return specific startup in json format with status success if startup_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      get :show, params: params_1
      expect(parse_json(response.body)).to eq(parse_json(startup.as_json(methods: [:assessments_risk_list, :members, :startup_admins]).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if startup_admin try to request startup that doesnt belong to the startup_admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      get :show, params: params_3
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return specific startup in json format with status success if member authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      get :show, params: params_1
      expect(parse_json(response.body)).to eq(parse_json(startup.as_json(methods: [:assessments_risk_list, :members, :startup_admins]).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if startup_admin try to request startup that doesnt belong to the startup_admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      get :show, params: params_3
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PUT update action' do
    let!(:params_1) { ActionController::Parameters.new({'id': startup.id}) }
    let!(:params)   { ActionController::Parameters.new({ startup: {name: "New startup name", admins_startups_attributes: [{admin_id: admins.first.id}, {admin_id: admins.last.id}, {admin_id: admin.id}] }}) }
    let!(:params_2) { ActionController::Parameters.new({ startup: {name: "New startup name", admins_startups_attributes: [{admin_id: admin.id}] }}) }
    let!(:params_3) { ActionController::Parameters.new({'id': startups_2.first.id}) }

    before { params_1.permit! }
    before { params.permit! }
    before { params_2.permit! }
    before { params_3.permit! }

    it 'return updated startup with admins who assigned to the startup in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      put :update, params: params_1.merge(params)
      startup.reload
      expect(parse_json(response.body)).to eq(parse_json(Startup.find(startup.id).as_json(methods: :admins_for_startup).to_json))
      expect(Startup.find(startup.id).admins.count).to eq(2)
      expect(Startup.find(startup.id).admin_ids).to eq([admins.first.id, admins.last.id])
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if super_admin try to update startup that doesnt belong to the current accelerator' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator_2.id}"})
      sign_in super_admin
      put :update, params: params_1.merge(params)
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return updated startup with admins who assigned to the startup in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in  admins.first
      put :update, params: params_1.merge(params)
      startup.reload
      expect(parse_json(response.body)).to eq(parse_json(Startup.find(startup.id).as_json(methods: :admins_for_startup).to_json))
      expect(Startup.find(startup.id).admins.count).to eq(1)
      expect(Startup.find(startup.id).admin_ids).to eq([admins.first.id])
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if admin try to request startup that doesnt belong to the admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      put :update, params: params_3.merge(params)
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return updated startup in json format with status success if startup_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      put :update, params: params_1.merge(params)
      startup.reload
      expect(parse_json(response.body)).to eq(parse_json(Startup.find(startup.id).to_json))
      expect(Startup.find(startup.id).admins.count).to eq(1)
      expect(Startup.find(startup.id).admin_ids).to eq([admins.first.id])
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if startup_admin try to request startup that doesnt belong to the startup_admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      put :update, params: params_3.merge(params)
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return error with status 403 if member authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      put :update, params: params_1.merge(params)
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end
end
