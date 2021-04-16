require 'rails_helper'

RSpec.describe StartupsController, type: :controller do
  it { should use_before_action(:authenticate_user!) }

  let!(:accelerator)          { create(:accelerator) }
  let!(:accelerator_2)        { create(:accelerator) }
  let!(:super_admin)          { create(:super_admin, accelerator_id: accelerator.id) }
  let!(:admins)               { create_list(:admin, 3, accelerator_id: accelerator.id) }
  let!(:admin)                { create(:admin, accelerator_id: accelerator_2.id) }
  let!(:startup)              { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.first.id}]) }
  let!(:startup_admin)        { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup.id) }
  let!(:member)               { create(:member, startup_id: startup.id, accelerator_id: accelerator.id) }

  describe 'POST create action' do
    let!(:params)   { ActionController::Parameters.new({ startup: {name: "New startup", admins_startups_attributes: [{admin_id: admins.first.id}, {admin_id: admins.last.id}, {admin_id: admin.id}] }}) }
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

    it 'return error with status 403 if super_admin try to assign all admins to the startup that dont belong to the super_admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      post :create, params: params_2
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
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
