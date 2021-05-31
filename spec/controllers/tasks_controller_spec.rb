require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:set_task) }

  let!(:accelerator)          { create(:accelerator) }
  let!(:accelerator_2)        { create(:accelerator) }
  let!(:super_admin)          { create(:super_admin) }
  let!(:super_admin_2)        { create(:super_admin) }
  let!(:admin)                { create(:admin, accelerator_id: accelerator.id) }
    let!(:startup)            { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
  let!(:admin_2)              { create(:admin, accelerator_id: accelerator.id) }
    let!(:startup_2)          { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin_2.id}]) }
  let!(:admin_3)              { create(:admin, accelerator_id: accelerator_2.id) }
    let!(:startup_3)          { create(:startup, accelerator_id: accelerator_2.id, admins_startups_attributes: [{admin_id: admin_3.id}]) }
    let!(:startup_admin)      { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup.id) }
    let!(:startup_admin_4)    { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup.id) }
    let!(:startup_admin_2)    { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup_2.id) }
    let!(:startup_admin_3)    { create(:startup_admin, accelerator_id: accelerator_2.id, startup_id: startup_3.id) }
    let!(:member)             { create(:member, startup_id: startup.id, accelerator_id: accelerator.id) }
    let!(:member_2)           { create(:member, startup_id: startup.id, accelerator_id: accelerator.id) }
    let!(:member_3)           { create(:member, startup_id: startup_2.id, accelerator_id: accelerator.id) }
    let!(:member_4)           { create(:member, startup_id: startup_3.id, accelerator_id: accelerator_2.id) }
  let!(:assessment)           { create(:assessment) }
    let!(:category)           { create(:category, assessment_id: assessment.id) }
      let!(:sub_category)     { create(:sub_category, category_id: category.id) }
        let!(:stage)          { create(:stage, sub_category_id: sub_category.id) }
          let!(:tasks)        { create_list(:task, 2, stage_id: stage.id, task_users_attributes: [{user_id: member.id}, {user_id: member_2.id}, {user_id: startup_admin.id}]) }
          let!(:tasks_3)      { create_list(:task, 2, stage_id: stage.id, task_users_attributes: [{user_id: member.id}, {user_id: startup_admin.id}]) }
          let!(:tasks_2)      { create_list(:task, 4, stage_id: stage.id, task_users_attributes: [{user_id: member_3.id}, {user_id: startup_admin_2.id}]) }
          let!(:tasks_4)      { create_list(:task, 4, stage_id: stage.id, task_users_attributes: [{user_id: member_4.id}, {user_id: startup_admin_3.id}]) }
          let!(:tasks_5)      { create_list(:task, 4, stage_id: stage.id, task_users_attributes: [{user_id: member_2.id}, {user_id: startup_admin_4.id}]) }


  describe 'GET index action' do
    let!(:params) { ActionController::Parameters.new({'startup_id': startup.id}) }

    before { params.permit! }

    it 'return all tasks of the accelerator of the super_admin in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      get :index, params: params
      expect(parse_json(response.body)[0][1]).to eq(1)
      expect(parse_json(response.body)[1][1].count).to eq(Task.joins(:users).tasks_for_startup(startup.id).distinct.count)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return all tasks of the startups that were created by the current admin in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      get :index, params: params
      expect(parse_json(response.body)[0][1]).to eq(1)
      expect(parse_json(response.body)[1][1].count).to eq(Task.joins(:users).tasks_for_startup(startup.id).distinct.count)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return all tasks of the startup of the current startup_admin in json format with status success if startup_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      get :index, params: params
      expect(parse_json(response.body)[1][1].count).to eq(startup_admin.tasks.count)
      expect(recursively_delete_timestamps(parse_json(response.body)[1][1])).to eq(parse_json(startup_admin.tasks.with_all_required_info_for_tasks.limit(10).as_json(methods: :members_for_task).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return all tasks for current member in json format with status success if member authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      get :index
      expect(parse_json(response.body)[1][1].count).to eq(member.tasks.count)
      expect(recursively_delete_timestamps(parse_json(response.body)[1][1])).to eq(parse_json(member.tasks.with_all_required_info_for_tasks.limit(10).as_json(methods: :members_for_task).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET show action' do
    let!(:params_1) { ActionController::Parameters.new({'id': tasks.first.id}) }
    let!(:params_2) { ActionController::Parameters.new({'id': tasks_2.first.id}) }
    let!(:params_3) { ActionController::Parameters.new({'id': tasks_4.first.id}) }

    before { params_1.permit! }
    before { params_2.permit! }
    before { params_3.permit! }

    it 'return specific task in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      get :show, params: params_1
      expect(parse_json(response.body)).to eq(parse_json(Task.with_all_required_info_for_tasks.where(id: tasks.first.id).first.as_json(methods: :members_for_task).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return specific task in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      get :show, params: params_1
      expect(parse_json(response.body)).to eq(parse_json(Task.with_all_required_info_for_tasks.where(id: tasks.first.id).first.as_json(methods: :members_for_task).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if task doesnt belong to admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      get :show, params: params_2
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return specific task in json format with status success if startup_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      get :show, params: params_1
      expect(parse_json(response.body)).to eq(parse_json(Task.with_all_required_info_for_tasks.where(id: tasks.first.id).first.as_json(methods: :members_for_task).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if task doesnt belong to startup_admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      get :show, params: params_2
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return specific task in json format with status success if member authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      get :show, params: params_1
      expect(parse_json(response.body)).to eq(parse_json(Task.with_all_required_info_for_tasks.where(id: tasks.first.id).first.as_json(methods: :members_for_task).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if task doesnt belong to member' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      get :show, params: params_2
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'POST create action' do
    let!(:params)   { ActionController::Parameters.new({ task: {title: "Task", stage_id: stage.id, priority: "low", due_date: DateTime.now, task_users_attributes: [{user_id: member.id}, {user_id: startup_admin.id}] }}) }

    before { params.permit! }

    it 'return new task with users who assigned to the task in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      post :create, params: params
      expect(parse_json(response.body)).to eq(parse_json(Task.last.as_json(methods: :members_for_task).to_json))
      expect(Task.last.users.count).to eq(3)
      expect(Task.last.users.where(type: "Member").first).to eq(Member.find(member.id))
      expect(Task.last.users.where(type: "StartupAdmin").first).to eq(StartupAdmin.find(startup_admin.id))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    it 'return new task with users who assigned to the task in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      post :create, params: params
      expect(parse_json(response.body)).to eq(parse_json(Task.last.as_json(methods: :members_for_task).to_json))
      expect(Task.last.users.count).to eq(3)
      expect(Task.last.users.where(type: "Member").first).to eq(Member.find(member.id))
      expect(Task.last.users.where(type: "StartupAdmin").first).to eq(StartupAdmin.find(startup_admin.id))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    it 'return new task with users who assigned to the task in json format with status success if startup_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin_4
      post :create, params: params
      expect(parse_json(response.body)).to eq(parse_json(Task.last.as_json(methods: :members_for_task).to_json))
      expect(Task.last.users.count).to eq(3)
      expect(Task.last.users.where(type: "Member").first).to eq(Member.find(member.id))
      expect(Task.last.users.where(type: "StartupAdmin").first).to eq(StartupAdmin.find(startup_admin.id))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
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

  describe 'PUT update action' do
    let!(:task_2)   { create(:task, stage_id: stage.id, task_users_attributes: [{user_id: member.id}, {user_id: startup_admin.id}]) }
    let!(:params)   { ActionController::Parameters.new({ task: { title: "New Task", stage_id: stage.id, priority: "high", due_date: DateTime.now, task_users_attributes: [{user_id: member_2.id}] }}) }
    let!(:params_2) { ActionController::Parameters.new({ 'id': task_2.id}) }
    let!(:params_3) { ActionController::Parameters.new({ 'id': tasks_2.first.id}) }

    before { params.permit! }
    before { params_2.permit! }
    before { params_3.permit! }

    it 'return updated task and assigned new users to the task in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      expect(task_2.users.count).to eq(2)
      sign_in super_admin
      put :update, params: params.merge(params_2)
      task_2.reload
      expect(parse_json(response.body)).to eq(parse_json(task_2.as_json(methods: :members_for_task).to_json))
      expect(task_2.title).to eq('New Task')
      expect(task_2.users.count).to eq(3)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return updated task and assigned new users to the task in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      expect(task_2.users.count).to eq(2)
      sign_in admin
      put :update, params: params.merge(params_2)
      task_2.reload
      expect(parse_json(response.body)).to eq(parse_json(task_2.as_json(methods: :members_for_task).to_json))
      expect(task_2.title).to eq('New Task')
      expect(task_2.users.count).to eq(3)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if task doesnt belong to admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      put :update, params: params.merge(params_3)
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return updated task and assigned new users to the task in json format with status success if startup_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      expect(task_2.users.count).to eq(2)
      sign_in startup_admin
      put :update, params: params.merge(params_2)
      task_2.reload
      expect(parse_json(response.body)).to eq(parse_json(task_2.as_json(methods: :members_for_task).to_json))
      expect(task_2.title).to eq('New Task')
      expect(task_2.users.count).to eq(3)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if task doesnt belong to startup_admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      put :update, params: params.merge(params_3)
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return error with status 403 if member authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      put :update, params: params.merge(params_3)
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PUT mark_task_as_completed action' do
    let!(:task_2)  { create(:task, stage_id: stage.id, status: 0, task_users_attributes: [{user_id: member.id}, {user_id: startup_admin.id}]) }
    let!(:params)  { ActionController::Parameters.new({'id': task_2.id}) }
    let!(:params_2) { ActionController::Parameters.new({ 'id': tasks_4.first.id}) }
    let!(:params_3) { ActionController::Parameters.new({ 'id': tasks_2.first.id}) }
    let!(:params_4) { ActionController::Parameters.new({ 'id': tasks_5.first.id}) }

    before { params.permit! }
    before { params_2.permit! }
    before { params_3.permit! }
    before { params_4.permit! }

    it 'return updated task status to completed in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      put :mark_task_as_completed, params: params
      task_2.reload
      expect(parse_json(response.body)).to eq(parse_json({new_task_status: task_2.status}.to_json))
      expect(task_2.status).to eq('completed')
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return updated task status to completed in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      put :mark_task_as_completed, params: params
      task_2.reload
      expect(parse_json(response.body)).to eq(parse_json({new_task_status: task_2.status}.to_json))
      expect(task_2.status).to eq('completed')
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if task doesnt belong to admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      put :mark_task_as_completed, params: params_3
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return updated task status to completed in json format with status success if startup_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      put :mark_task_as_completed, params: params
      task_2.reload
      expect(parse_json(response.body)).to eq(parse_json({new_task_status: task_2.status}.to_json))
      expect(task_2.status).to eq('completed')
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if task doesnt belong to startup_admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      put :mark_task_as_completed, params: params_4
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return updated task status to completed in json format with status success if member authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      put :mark_task_as_completed, params: params
      task_2.reload
      expect(parse_json(response.body)).to eq(parse_json({new_task_status: task_2.status}.to_json))
      expect(task_2.status).to eq('completed')
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if task doesnt belong to startup_admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      put :mark_task_as_completed, params: params_4
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE destroy action' do
    let!(:task_3)    { create(:task, stage_id: stage.id, task_users_attributes: [{user_id: member.id}, {user_id: startup_admin.id}]) }
    let!(:params)  { ActionController::Parameters.new({'id': task_3.id}) }
    let!(:params_2) { ActionController::Parameters.new({ 'id': tasks_2.first.id}) }

    before { params.permit! }
    before { params_2.permit! }

    it 'return successfully message in json if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      delete :destroy, params: params
      expect(Task.find_by_id(task_3.id)).to eq(nil)
      expect(response.body).to eq({message: 'Successfully destroyed'}.to_json)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:success)
    end

    it 'return successfully message in json if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      delete :destroy, params: params
      expect(Task.find_by_id(task_3.id)).to eq(nil)
      expect(response.body).to eq({message: 'Successfully destroyed'}.to_json)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if task doesnt belong to admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      delete :destroy, params: params_2
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return successfully message in json if startup_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      delete :destroy, params: params
      expect(Task.find_by_id(task_3.id)).to eq(nil)
      expect(response.body).to eq({message: 'Successfully destroyed'}.to_json)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if task doesnt belong to startup_admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      delete :destroy, params: params_2
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
