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
  let!(:startup_admin)        { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startups.first.id) }
  let!(:member)               { create(:member, startup_id: startups.first.id, accelerator_id: accelerator.id) }
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

    it "return info in json format about current StartupAdmin with startup if startup_admin is authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      get :profile
      expect(parse_json(response.body)).to eq(parse_json(StartupAdmin.find(startup_admin.id).as_json(methods: :startup).to_json))
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
      expect([parse_json(response.body)[2][1][0]['first_name'], parse_json(response.body)[2][1][1]['first_name']]).to eq([member_1.first_name, member_2.first_name])
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
      expect([parse_json(response.body)[2][1][0]['first_name'], parse_json(response.body)[2][1][1]['first_name']]).to eq([member_1.first_name, member_2.first_name])
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

    it 'return all users are searched of the startup of the current startup_admin in json format with status success if startup_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      get :index, params: params.merge(params_2)
      expect(parse_json(response.body)[0]).to eq(["current_page", 1])
      expect(parse_json(response.body)[1]).to eq(["total_pages", 1])
      expect(parse_json(response.body)[2][1].count).to eq(2)
      expect([parse_json(response.body)[2][1][0]['first_name'], parse_json(response.body)[2][1][1]['first_name']]).to eq([member_1.first_name, member_2.first_name])
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
    let!(:params_2)   {ActionController::Parameters.new({user: {email: 'user2@gmail.com', type: "StartupAdmin", startup_id: startups.first.id}})}
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

    it "return error in json with status forbidden if super_admin try create startup_admin" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      post :create, params: params_2
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it "return startup_admin who was created by current admin" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      post :create, params: params_2
      expect(parse_json(response.body)).to eq(parse_json(StartupAdmin.last.to_json))
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

    it "return member who was created by current startup_admin" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      post :create, params: params_3
      expect(parse_json(response.body)).to eq(parse_json(Member.last.to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    it "return error in json with status forbidden if startup_admin try create admin" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
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

    it 'return updated info about current user in json format with status success if startup_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      put :update_profile, params: params
      startup_admin.reload
      expect(parse_json(response.body)).to eq(parse_json(startup_admin.to_json))
      expect([startup_admin.first_name, startup_admin.last_name]).to eq([ params[:user][:first_name], params[:user][:last_name] ])
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 422 if super_admin user try to update email and select already existed email' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      put :update_profile, params: params_2
      expect(response.body).to eq({"email":["has already been taken"]}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'return updated info about current user in json format with status success if startup_admin authenticated' do
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

    it 'return updated info about current user in json format with status success if startup_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      expect(startup_admin.email_notification).to eq(true)
      put :update_email_notification, params: params
      startup_admin.reload
      expect(parse_json(response.body)).to eq(parse_json(startup_admin.to_json))
      expect(startup_admin.email_notification).to eq(false)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return updated info about current user in json format with status success if startup_admin authenticated' do
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
