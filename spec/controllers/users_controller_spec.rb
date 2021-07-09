require 'rails_helper'

RSpec.describe Admins::UsersController, type: :controller do
  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:set_profile) }

  let!(:accelerator)          { create(:accelerator) }
  let!(:accelerator_2)        { create(:accelerator) }
  let!(:super_admin)          { create(:super_admin) }
  let!(:admins)               { create_list(:admin, 3, accelerator_id: accelerator.id) }
  let!(:admin)                { create(:admin, accelerator_id: accelerator_2.id) }
  let!(:startups)             { create_list(:startup, 2, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.first.id}]) }
  let!(:startups_2)           { create_list(:startup, 2, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.last.id}]) }
  let!(:team_lead)            { create(:team_lead, accelerator_id: accelerator.id, startup_id: startups.first.id) }
  let!(:member)               { create(:member, startup_id: startups.first.id, accelerator_id: accelerator.id) }
  let!(:member_2)             { create(:member, startup_id: startups_2.first.id, accelerator_id: accelerator_2.id) }
  let!(:member_3)             { create(:member, startup_id: startups.first.id, accelerator_id: accelerator.id) }

  describe 'GET profile action' do
    it "return info in json format about current SuperAdmin if super_admin is authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      get :profile
      expect(parse_json(response.body)).to eq(parse_json(SuperAdmin.find(super_admin.id).to_json))
    end

    it "return info in json format about current Admin with startups if admin is authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      get :profile
      expect(parse_json(response.body)).to eq(parse_json(Admin.find(admins.first.id).as_json(methods: :startups).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return info in json format about current TeamLead with startup if team_lead is authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in team_lead
      get :profile
      expect(parse_json(response.body)).to eq(parse_json(TeamLead.find(team_lead.id).as_json(methods: :startup).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return info in json format about current Member with startup if member is authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      get :profile
      expect(parse_json(response.body)).to eq(parse_json(Member.find(member.id).as_json(methods: :startup).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET index action' do
    let!(:params)      { ActionController::Parameters.new({'startup_id': startups.first.id}) }
    let!(:params_1)    { ActionController::Parameters.new({'startup_id': startups_2.last.id}) }
    let!(:params_2)    { ActionController::Parameters.new({'search': 'Jonson'}) }

    let!(:member_1)    { create(:member, first_name: "Boris", last_name: "Jonson", startup_id: startups.first.id, accelerator_id: accelerator.id) }
    let!(:member_2)    { create(:member, first_name: "Ann", last_name: "Jonson", startup_id: startups.first.id, accelerator_id: accelerator.id) }
    let!(:members_1)   { create_list(:member, 3, startup_id: startups.last.id, accelerator_id: accelerator.id) }
    let!(:members_2)   { create_list(:member, 3, startup_id: startups.first.id, accelerator_id: accelerator.id) }

    before do
       params.permit!
       params_1.permit!
       params_2.permit!
    end

    it 'return all users are searched of the startup for super_admin in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      get :index, params: params.merge(params_2)
      expect(parse_json(response.body)[0]).to eq(["current_page", 1])
      expect(parse_json(response.body)[1]).to eq(["total_pages", 1])
      expect(parse_json(response.body)[2][1].count).to eq(2)
      expect([parse_json(response.body)[2][1][0]['first_name'], parse_json(response.body)[2][1][1]['first_name']]).to eq(Member.where(id: [member_1.id, member_2.id]).order(first_name: :asc).map(&:first_name))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return error in json with status forbidden if super_admin request a startup isnt belonged to the current accelerator" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator_2.id}"})
      sign_in super_admin
      get :index, params: params_1.merge(params_2)
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return all users are searched of the startup for admin in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      get :index, params: params.merge(params_2)
      expect(parse_json(response.body)[0]).to eq(["current_page", 1])
      expect(parse_json(response.body)[1]).to eq(["total_pages", 1])
      expect(parse_json(response.body)[2][1].count).to eq(2)
      expect([parse_json(response.body)[2][1][0]['first_name'], parse_json(response.body)[2][1][1]['first_name']]).to eq(Member.where(id: [member_1.id, member_2.id]).order(first_name: :asc).map(&:first_name))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return error in json with status forbidden if admin request a startup isnt belonged to the admin" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      get :index, params: params_1.merge(params_2)
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return all users are searched of the startup of the current team_lead in json format with status success if team_lead authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in team_lead
      get :index, params: params.merge(params_2)
      expect(parse_json(response.body)[0]).to eq(["current_page", 1])
      expect(parse_json(response.body)[1]).to eq(["total_pages", 1])
      expect(parse_json(response.body)[2][1].count).to eq(2)
      expect([parse_json(response.body)[2][1][0]['first_name'], parse_json(response.body)[2][1][1]['first_name']]).to eq(Member.where(id: [member_1.id, member_2.id]).order(first_name: :asc).map(&:first_name))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return error in json with status forbidden if member tries perform this action" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      get :index, params: params.merge(params_2)
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST create action" do
    let!(:params)     {ActionController::Parameters.new({user: {email: 'user@gmail.com', type: "Admin"}})}
    let!(:params_2)   {ActionController::Parameters.new({user: {email: 'user2@gmail.com', type: "TeamLead", startup_id: startups.first.id}})}
    let!(:params_3)   {ActionController::Parameters.new({user: {email: 'user3@gmail.com', type: "Member"}})}
    let!(:params_4)   {ActionController::Parameters.new({user: {email: 'user4@gmail.com', type: "Member", startup_id: startups.first.id}})}

    before {params.permit!}
    before {params_2.permit!}
    before {params_3.permit!}
    before {params_4.permit!}

    it "return admin who was created by current super_admin" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      post :create, params: params
      expect(parse_json(response.body)).to eq(parse_json(Admin.last.to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    it "return member who was created by current super_admin" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      post :create, params: params_4
      expect(parse_json(response.body)).to eq(parse_json(Member.last.to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    it "return error in json with status forbidden if super_admin try create team_lead" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      post :create, params: params_2
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it "return team_lead who was created by current admin" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      post :create, params: params_2
      expect(parse_json(response.body)).to eq(parse_json(TeamLead.last.to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    it "return error in json with status forbidden if admin try create admin" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      post :create, params: params
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it "return member who was created by current team_lead" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in team_lead
      post :create, params: params_3
      expect(parse_json(response.body)).to eq(parse_json(Member.last.to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    it "return error in json with status forbidden if team_lead try create admin" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in team_lead
      post :create, params: params
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it "return error in json with status forbidden if member try create any user" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      post :create, params: params
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PUT change_password action' do
    let!(:member_2) { create(:member, startup_id: startups.first.id, accelerator_id: accelerator.id, password: "123456") }

    let!(:params) { ActionController::Parameters.new(
      user: {
        current_password: "123456",
        password: "qwerty",
      }
    )}

    before { params.permit! }

    it 'return updated password of current user in json format with status success' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member_2
      expect(member_2.valid_password?('qwerty')).to eq(false)
      put :change_password, params: params
      expect(parse_json(response.body)).to eq(parse_json(member_2.to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
      member_2.reload
      expect(member_2.valid_password?('qwerty')).to eq(true)
    end

    let!(:params_2) { ActionController::Parameters.new(
      user: {
        current_password: "123456_2",
        password: "qwerty"
      }
    )}

    before { params_2.permit! }

    it 'return error if current_password was not provide or was incorrect' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member_2
      put :change_password, params: params_2
      expect(parse_json(response.body)).to eq([["current_password", ["is invalid"]]])
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'PUT update_profile action' do
    let!(:params) { ActionController::Parameters.new(
      user: {
        first_name: "Anakin",
        last_name: "Skywalker",
        phone_number: "222222222",
        email: "emailthatwillbeneverseelcted@gmail.com"
      }
    )}

    let!(:params_2) { ActionController::Parameters.new(
      user: {
        email: member_3.email
      }
    )}

    before { params.permit! }
    before { params_2.permit! }

    it 'return updated info about current user in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      put :update_profile, params: params
      super_admin.reload
      expect(parse_json(response.body)).to eq(parse_json(super_admin.to_json))
      expect([super_admin.first_name, super_admin.last_name]).to eq([ params[:user][:first_name], params[:user][:last_name] ])
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 422 if super_admin user try to update email and select already existed email' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      put :update_profile, params: params_2
      expect(response.body).to eq({"email":["has already been taken"]}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'return updated info about current user in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      put :update_profile, params: params
      admins.first.reload
      expect(parse_json(response.body)).to eq(parse_json(admins.first.to_json))
      expect([admins.first.first_name, admins.first.last_name]).to eq([ params[:user][:first_name], params[:user][:last_name] ])
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 422 if super_admin user try to update email and select already existed email' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      put :update_profile, params: params_2
      expect(response.body).to eq({"email":["has already been taken"]}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'return updated info about current user in json format with status success if team_lead authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in team_lead
      put :update_profile, params: params
      team_lead.reload
      expect(parse_json(response.body)).to eq(parse_json(team_lead.to_json))
      expect([team_lead.first_name, team_lead.last_name]).to eq([ params[:user][:first_name], params[:user][:last_name] ])
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 422 if super_admin user try to update email and select already existed email' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in team_lead
      put :update_profile, params: params_2
      expect(response.body).to eq({"email":["has already been taken"]}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'return updated info about current user in json format with status success if team_lead authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      put :update_profile, params: params
      member.reload
      expect(parse_json(response.body)).to eq(parse_json(member.to_json))
      expect([member.first_name, member.last_name]).to eq([ params[:user][:first_name], params[:user][:last_name] ])
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 422 if super_admin user try to update email and select already existed email' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      put :update_profile, params: params_2
      expect(response.body).to eq({"email":["has already been taken"]}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE destroy action' do
    let!(:params)   { ActionController::Parameters.new({'id': member.id}) }
    let!(:params_2) { ActionController::Parameters.new({'id': member_2.id}) }
    let!(:params_3) { ActionController::Parameters.new({'id': team_lead.id}) }

    before { params.permit! }
    before { params_2.permit! }
    before { params_3.permit! }

    it 'return successfully message about destroy user in json if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      delete :destroy, params: params
      expect(Member.find_by_id(member.id)).to eq(nil)
      expect(response.body).to eq({message: 'Successfully destroyed'}.to_json)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:success)
    end

    it "return error in json with status forbidden if super_admin try delete user that dosnt belong to the current accelerator" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      delete :destroy, params: params_2
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return successfully message about destroy user in json if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      delete :destroy, params: params
      expect(Member.find_by_id(member.id)).to eq(nil)
      expect(response.body).to eq({message: 'Successfully destroyed'}.to_json)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:success)
    end

    it "return error in json with status forbidden if admin try delete user that dosnt belong to the startups were created by the admin" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      delete :destroy, params: params_2
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it "return error in json with status forbidden if team_lead tries perform this action" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in team_lead
      delete :destroy, params: params
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it "return error in json with status forbidden if member tries perform this action" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      delete :destroy, params: params_3
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PUT update_email_notification action' do
    let!(:params) { ActionController::Parameters.new(email_notification: "false")}

    let!(:params_2) { ActionController::Parameters.new()}

    before { params.permit! }
    before { params_2.permit! }

    it 'return updated info about current user in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      expect(super_admin.email_notification).to eq(true)
      put :update_email_notification, params: params
      super_admin.reload
      expect(parse_json(response.body)).to eq(parse_json(super_admin.to_json))
      expect(super_admin.email_notification).to eq(false)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return updated info about current user in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      expect(admins.first.email_notification).to eq(true)
      put :update_email_notification, params: params
      admins.first.reload
      expect(parse_json(response.body)).to eq(parse_json(admins.first.to_json))
      expect(admins.first.email_notification).to eq(false)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return updated info about current user in json format with status success if team_lead authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in team_lead
      expect(team_lead.email_notification).to eq(true)
      put :update_email_notification, params: params
      team_lead.reload
      expect(parse_json(response.body)).to eq(parse_json(team_lead.to_json))
      expect(team_lead.email_notification).to eq(false)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return updated info about current user in json format with status success if team_lead authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      expect(member.email_notification).to eq(true)
      put :update_email_notification, params: params
      member.reload
      expect(parse_json(response.body)).to eq(parse_json(member.to_json))
      expect(member.email_notification).to eq(false)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return did not update info about current user in json format with status success if user dont provide email_notification param' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      expect(member.email_notification).to eq(true)
      put :update_email_notification, params: params_2
      member.reload
      expect(parse_json(response.body)).to eq(parse_json(member.to_json))
      expect(member.email_notification).to eq(true)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end
  end
end
