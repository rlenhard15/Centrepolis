require 'rails_helper'

RSpec.describe Admins::MembersController, type: :controller do
  it { should use_before_action(:authenticate_user!) }

  let!(:accelerator)           { create(:accelerator) }
  let!(:accelerator_2)         { create(:accelerator) }
  let!(:super_admin)           { create(:super_admin, accelerator_id: accelerator.id) }
  let!(:admins)                { create_list(:admin, 2, accelerator_id: accelerator.id) }
  let!(:admin)                 { create(:admin, accelerator_id: accelerator_2.id) }
  let!(:startup)               { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.first.id}]) }
  let!(:startup_2)             { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.last.id}]) }
  let!(:startup_3)             { create(:startup, accelerator_id: accelerator_2.id, admins_startups_attributes: [{admin_id: admin.id}]) }
  let!(:startup_admin)         { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup.id) }
  let!(:startup_admin_2)       { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup_2.id) }
  let!(:members)               { create_list(:member, 3, startup_id: startup.id, accelerator_id: accelerator.id) }
  let!(:members_2)             { create_list(:member, 2, startup_id: startup_2.id, accelerator_id: accelerator.id) }
  let!(:members_3)             { create_list(:member, 4, startup_id: startup_3.id, accelerator_id: accelerator_2.id) }
  let!(:assessment)            { create(:assessment) }
    let!(:assessment_progress) { create(:assessment_progress, member_id: members.first.id, assessment_id: assessment.id) }
    let!(:category)            { create(:category, assessment_id: assessment.id) }
      let!(:sub_category)      { create(:sub_category, category_id: category.id) }
        let!(:stage)           { create(:stage, sub_category_id: sub_category.id) }

  describe "GET index action" do
    it "return members for current SuperAdmin with list of assessment_risk if user authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      get :index
      expect(parse_json(response.body).count).to eq(5)
      expect(parse_json(response.body)).to eq(recursively_delete_timestamps(accelerator.users.where(type: "Member").as_json(include: :startup, methods: [:assessments_risk_list])))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return members for current Admin with list of assessment_risk if user authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      get :index
      expect(parse_json(response.body).count).to eq(3)
      expect(parse_json(response.body)).to eq(recursively_delete_timestamps(Member.where(startup_id: admins.first.startup_ids).as_json(include: :startup, methods: [:assessments_risk_list])))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return members for current StartupAdmin with list of assessment_risk if user authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      get :index
      expect(parse_json(response.body).count).to eq(3)
      expect(parse_json(response.body)).to eq(recursively_delete_timestamps(Member.where(startup_id: startup_admin.startup_id).as_json(include: :startup, methods: [:assessments_risk_list])))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return error in json with status forbidden if sign in as member" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in members.first
      get :index
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST create action" do
    let!(:params)     {ActionController::Parameters.new({user: {email: 'member@gmail.com', startup_id: startup.id}})}
    let!(:params_2)   {ActionController::Parameters.new({user: {email: 'member@gmail.com', startup_id: startup_3.id}})}

    before {params.permit!}
    before {params_2.permit!}

    it "return member if SuperAdmin is authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      post :create, params: params
      expect(parse_json(response.body)).to eq(parse_json(Member.last.to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    it "return error in json with status forbidden if SuperAdmin try create member to start doesnt belong to him" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      post :create, params: params_2
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it "return member if Admin is authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      post :create, params: params
      expect(parse_json(response.body)).to eq(parse_json(Member.last.to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    it "return error in json with status forbidden if Admin try create member to start doesnt belong to him" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      post :create, params: params_2
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it "return member if StartupAdmin is authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      post :create, params: params
      expect(parse_json(response.body)).to eq(parse_json(Member.last.to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    it "return error in json with status forbidden if user sign in as member" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in members.first
      post :create, params: params
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end
end
