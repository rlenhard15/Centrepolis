require 'rails_helper'

RSpec.describe Admins::StartupAdminsController, type: :controller do
  it { should use_before_action(:authenticate_user!) }

  let!(:accelerator)          { create(:accelerator) }
  let!(:accelerator_2)        { create(:accelerator) }
  let!(:super_admin)          { create(:super_admin, accelerator_id: accelerator.id) }
  let!(:super_admin_2)        { create(:super_admin, accelerator_id: accelerator_2.id) }
  let!(:admins)               { create_list(:admin, 3, accelerator_id: accelerator.id) }
  let!(:admin)                { create(:admin, accelerator_id: accelerator_2.id) }
  let!(:startup)              { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.first.id}]) }
  let!(:startup_2)            { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.last.id}]) }
  let!(:startup_admin)        { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup.id) }
  let!(:startup_admin_2)      { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup_2.id) }
  let!(:member)               { create(:member, startup_id: startup.id, accelerator_id: accelerator.id) }

  describe "GET index action" do
    it "return startup_admins of the accelerator with their startup if super_admin authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      get :index
      expect(parse_json(response.body).count).to eq(2)
      expect(recursively_delete_timestamps(parse_json(response.body))).to eq(recursively_delete_timestamps(StartupAdmin.where(accelerator_id: super_admin.accelerator_id).as_json(include: :startup)))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return startup_admins with their startup of the current user startups if admin authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      get :index
      expect(parse_json(response.body).count).to eq(1)
      expect(recursively_delete_timestamps(parse_json(response.body))).to eq(recursively_delete_timestamps(StartupAdmin.where(startup_id: admins.first.startup_ids).as_json(include: :startup)))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return error in json with status forbidden if sign in as startup_admin" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      get :index
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it "return error in json with status forbidden if sign in as member" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      get :index
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST create action" do
    let!(:params)   {ActionController::Parameters.new({user: {email: 'startup_admin@gmail.com', startup_id: startup.id}})}
    let!(:params_2) {ActionController::Parameters.new({user: {email: 'startup_admin2@gmail.com', startup_id: startup_2.id}})}

    before {params.permit!}
    before {params_2.permit!}

    it "return startup_admin who was created by current admin" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      post :create, params: params
      expect(parse_json(response.body)).to eq(parse_json(StartupAdmin.last.to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    it "return error in json with status forbidden if current admin try to create startup_admin for a startup doesnt belong to him" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      post :create, params: params_2
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it "return error in json with status forbidden if sign in as super_admin" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      post :create, params: params
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it "return error in json with status forbidden if sign in as startup_admin" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      get :index
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it "return error in json with status forbidden if sign in as member" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      get :index
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end
end