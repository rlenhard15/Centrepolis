require 'rails_helper'

RSpec.describe Admins::TeamLeadsController, type: :controller do
  it { should use_before_action(:authenticate_user!) }

  let!(:accelerator)          { create(:accelerator) }
  let!(:accelerator_2)        { create(:accelerator) }
  let!(:super_admin)          { create(:super_admin) }
  let!(:super_admin_2)        { create(:super_admin) }
  let!(:admins)               { create_list(:admin, 3, accelerator_id: accelerator.id) }
  let!(:admin)                { create(:admin, accelerator_id: accelerator_2.id) }
  let!(:startup)              { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.first.id}]) }
  let!(:startup_2)            { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.last.id}]) }
  let!(:team_lead)            { create(:team_lead, accelerator_id: accelerator.id, startup_id: startup.id) }
  let!(:team_lead_2)          { create(:team_lead, accelerator_id: accelerator.id, startup_id: startup_2.id) }
  let!(:member)               { create(:member, startup_id: startup.id, accelerator_id: accelerator.id) }

  describe "GET index action" do
    it "return team_leads of the accelerator with their startup if super_admin authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      get :index
      expect(parse_json(response.body)[0]).to eq(["current_page", 1])
      expect(parse_json(response.body)[1][1].count).to eq(2)
      expect(recursively_delete_timestamps(parse_json(response.body)[1][1])).to eq(recursively_delete_timestamps(TeamLead.for_accelerator(accelerator.id).as_json(include: :startup)))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return team_leads with their startup of the current user startups if admin authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      get :index
      expect(parse_json(response.body)[0]).to eq(["current_page", 1])
      expect(parse_json(response.body)[1][1].count).to eq(1)
      expect(recursively_delete_timestamps(parse_json(response.body)[1][1])).to eq(recursively_delete_timestamps(TeamLead.where(startup_id: admins.first.startup_ids).for_accelerator(accelerator.id).as_json(include: :startup)))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return error in json with status forbidden if sign in as team_lead" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in team_lead
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
