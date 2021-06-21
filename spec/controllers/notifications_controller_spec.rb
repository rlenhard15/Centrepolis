require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:set_notification) }

  let!(:accelerator)          { create(:accelerator) }
  let!(:accelerator_2)        { create(:accelerator) }
  let!(:super_admin)          { create(:super_admin) }
  let!(:admins)               { create_list(:admin, 2, accelerator_id: accelerator.id) }
  let!(:startups)             { create_list(:startup, 2, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.first.id}]) }
  let!(:startup_admin)        { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startups.first.id) }
  let!(:member)               { create(:member, startup_id: startups.first.id, accelerator_id: accelerator.id) }
  let!(:assessment)           { create(:assessment) }
    let!(:category)           { create(:category, assessment_id: assessment.id) }
      let!(:sub_category)     { create(:sub_category, category_id: category.id) }
        let!(:stage)          { create(:stage, sub_category_id: sub_category.id) }
          let!(:tasks)        { create_list(:task, 2, stage_id: stage.id, task_users_attributes: [{user_id: member.id}, {user_id: startup_admin.id}, {user_id: super_admin.id, creator: true}, {user_id: admins.first.id}]) }
          let!(:tasks_2)      { create_list(:task, 2, stage_id: stage.id, task_users_attributes: [{user_id: member.id}, {user_id: admins.last.id, creator: true}, {user_id: startup_admin.id}]) }

  describe "GET index action" do
    it "return notifications for current super_admin" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      get :index
      expect(parse_json(response.body)[0]).to eq(["current_page", 1])
      expect(parse_json(response.body)[1][1].count).to eq(2)
      expect(parse_json(response.body)[1][1][0]['task']['created_by']['id']).to eq(tasks.first.users.where("task_users.creator IS true").first.id)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return notifications for current admin" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      get :index
      expect(parse_json(response.body)[0]).to eq(["current_page", 1])
      expect(parse_json(response.body)[1][1].count).to eq(2)
      expect(parse_json(response.body)[1][1][0]['task']['created_by']['id']).to eq(tasks.first.users.where("task_users.creator IS true").first.id)
      expect([parse_json(response.body)[1][1][0]['task']['id'], parse_json(response.body)[1][1][1]['task']['id']]).to eq([tasks.last.id, tasks.first.id])
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return notifications for current startup_admin" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      get :index
      expect(parse_json(response.body)[0]).to eq(["current_page", 1])
      expect(parse_json(response.body)[1][1].count).to eq(4)
      expect(parse_json(response.body)[1][1][0]['task']['created_by']['id']).to eq(tasks_2.first.users.where("task_users.creator IS true").first.id)
      expect([parse_json(response.body)[1][1][0]['task']['id'], parse_json(response.body)[1][1][1]['task']['id']]).to eq([tasks_2.last.id, tasks_2.first.id])
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return notifications for current member" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      get :index
      expect(parse_json(response.body)[0]).to eq(["current_page", 1])
      expect(parse_json(response.body)[1][1].count).to eq(4)
      expect(parse_json(response.body)[1][1][0]['task']['created_by']['id']).to eq(tasks_2.first.users.where("task_users.creator IS true").first.id)
      expect([parse_json(response.body)[1][1][0]['task']['id'], parse_json(response.body)[1][1][1]['task']['id']]).to eq([tasks_2.last.id, tasks_2.first.id])
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT mark_as_readed_all action" do

    it "return successful message in json format and update all notifications read statuses to true for current user if super_admin authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      expect(Notification.where(user_id: admins.first.id, read: false).count).to eq(2)
      put :mark_as_readed_all
      expect(Notification.where(user_id: super_admin.id, read: false).count).to eq(0)
      expect(response.body).to eq({message: "Successfully update read status to true for all user notifications"}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return successful message in json format and update all notifications read statuses to true for current user if admin authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      expect(Notification.where(user_id: admins.first.id, read: false).count).to eq(2)
      put :mark_as_readed_all
      expect(Notification.where(user_id: admins.first.id, read: false).count).to eq(0)
      expect(response.body).to eq({message: "Successfully update read status to true for all user notifications"}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return successful message in json format and update all notifications read statuses to true for current user if startup_admin authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      expect(Notification.where(user_id: startup_admin.id, read: false).count).to eq(4)
      put :mark_as_readed_all
      expect(Notification.where(user_id: startup_admin.id, read: false).count).to eq(0)
      expect(response.body).to eq({message: "Successfully update read status to true for all user notifications"}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return successful message in json format and update all notifications read statuses to true for current user if member authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      expect(Notification.where(user_id: member.id, read: false).count).to eq(4)
      put :mark_as_readed_all
      expect(Notification.where(user_id: member.id, read: false).count).to eq(0)
      expect(response.body).to eq({message: "Successfully update read status to true for all user notifications"}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT mark_as_readed action" do
    let!(:notification)   { create(:notification, task_id: tasks.first.id, user_id: super_admin.id) }
    let!(:notification_1) { create(:notification, task_id: tasks.first.id, user_id: admins.first.id) }
    let!(:notification_2) { create(:notification, task_id: tasks.first.id, user_id: startup_admin.id) }
    let!(:notification_3) { create(:notification, task_id: tasks.first.id, user_id: member.id) }

    let!(:params)     { ActionController::Parameters.new({'id': notification.id})}
    let!(:params_1)   { ActionController::Parameters.new({'id': notification_1.id})}
    let!(:params_2)   { ActionController::Parameters.new({'id': notification_2.id})}
    let!(:params_3)   { ActionController::Parameters.new({'id': notification_3.id})}

    before do
      params.permit!
      params_1.permit!
      params_2.permit!
      params_3.permit!
    end

    it "return successful message in json format and update one notification to true for current user if super_admin authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      expect(Notification.find_by_id(notification.id).read).to eq(false)
      put :mark_as_readed, params: params
      notification.reload
      expect(notification.read).to eq(true)
      expect(response.body).to eq({"read_status": true}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if notification doesnt belong to the super_admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      put :mark_as_readed, params: params_1
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it "return successful message in json format and update all notifications read statuses to true for current user if admin authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      expect(Notification.find_by_id(notification_1.id).read).to eq(false)
      put :mark_as_readed, params: params_1
      notification_1.reload
      expect(notification_1.read).to eq(true)
      expect(response.body).to eq({"read_status": true}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if notification doesnt belong to the admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admins.first
      put :mark_as_readed, params: params_2
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it "return successful message in json format and update all notifications read statuses to true for current user if startup_admin authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      expect(Notification.find_by_id(notification_2.id).read).to eq(false)
      put :mark_as_readed, params: params_2
      notification_2.reload
      expect(notification_2.read).to eq(true)
      expect(response.body).to eq({"read_status": true}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if notification doesnt belong to the startup_admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      put :mark_as_readed, params: params_3
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it "return successful message in json format and update all notifications read statuses to true for current user if member authenticated" do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      expect(Notification.find_by_id(notification_3.id).read).to eq(false)
      put :mark_as_readed, params: params_3
      notification_3.reload
      expect(notification_3.read).to eq(true)
      expect(response.body).to eq({"read_status": true}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if notification doesnt belong to the member' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      put :mark_as_readed, params: params_2
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end
end
