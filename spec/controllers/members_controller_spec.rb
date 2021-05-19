require 'rails_helper'

RSpec.describe Admins::MembersController, type: :controller do
  it { should use_before_action(:authenticate_user!) }

  let!(:accelerator)           { create(:accelerator) }
  let!(:accelerator_2)         { create(:accelerator) }
  let!(:super_admin)           { create(:super_admin) }
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

  describe "GET index action" do
    it "return members for current SuperAdmin with list of assessment_risk if user authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      get :index
      expect(parse_json(response.body).count).to eq(5)
      expect(parse_json(response.body)).to eq(recursively_delete_timestamps(Member.for_accelerator(accelerator.id).as_json(include: :startup)))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return members for current Admin with list of assessment_risk if user authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      get :index
      expect(parse_json(response.body).count).to eq(3)
      expect(parse_json(response.body)).to eq(recursively_delete_timestamps(Member.where(startup_id: admins.first.startup_ids).for_accelerator(accelerator.id).as_json(include: :startup)))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return members for current StartupAdmin with list of assessment_risk if user authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      get :index
      expect(parse_json(response.body).count).to eq(3)
      expect(parse_json(response.body)).to eq(recursively_delete_timestamps(Member.where(startup_id: startup_admin.startup_id).for_accelerator(accelerator.id).as_json(include: :startup)))
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
end
