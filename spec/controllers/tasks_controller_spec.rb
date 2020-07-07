require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:set_task) }

  let!(:accelerator)      { create(:accelerator) }
  let!(:admin)            { create(:admin, accelerator_id: accelerator.id) }
  let!(:admin_2)          { create(:admin, accelerator_id: accelerator.id) }
    let!(:customer)       { create(:customer, created_by: admin.id, accelerator_id: accelerator.id) }
    let!(:customer_2)     { create(:customer, created_by: admin_2.id, accelerator_id: accelerator.id) }
  let!(:assessment)       { create(:assessment) }
    let!(:category)       { create(:category, assessment_id: assessment.id) }
      let!(:sub_category) { create(:sub_category, category_id: category.id) }
        let!(:stage)      { create(:stage, sub_category_id: sub_category.id) }
          let!(:tasks)    { create_list(:task, 4, stage_id: stage.id, user_id: customer.id, created_by: admin.id) }
          let!(:tasks_2)  { create_list(:task, 4, stage_id: stage.id, user_id: customer_2.id, created_by: admin_2.id) }


  describe 'GET index action' do
    let!(:params) { ActionController::Parameters.new({'customer_id': customer.id}) }

    before { params.permit! }

    it 'return all tasks for current customer in json format with status success if customer authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in customer
      get :index
      expect(parse_json(response.body).count).to eq(customer.tasks.count)
      expect(parse_json(response.body)).to eq(parse_json(Task.where(user_id: customer.id).with_all_required_info_for_tasks.to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return all tasks for current admin in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      get :index, params: params
      expect(parse_json(response.body).count).to eq(admin.tasks.count)
      expect(parse_json(response.body)).to eq(parse_json(Task.where(created_by: admin.id).order(created_at: :asc).with_all_required_info_for_tasks.to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET show action' do
    let!(:params_1) { ActionController::Parameters.new({'id': tasks.first.id}) }
    let!(:params_2) { ActionController::Parameters.new({'id': tasks_2.first.id}) }

    before { params_1.permit! }
    before { params_2.permit! }

    it 'return specific task in json format with status success if customer authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in customer
      get :show, params: params_1
      expect(parse_json(response.body)).to eq(parse_json(Task.with_all_required_info_for_tasks.where(id: tasks.first.id).first.to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if task doesnt belong to customer' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in customer
      get :show, params: params_2
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return specific task in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      get :show, params: params_1
      expect(parse_json(response.body)).to eq(parse_json(Task.with_all_required_info_for_tasks.where(id: tasks.first.id).first.to_json))
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
  end

  describe 'POST create action' do
    let!(:params)   { ActionController::Parameters.new({ task: {title: "Task", stage_id: stage.id, priority: "low", due_date: DateTime.now, customer_id: customer.id }}) }

    before { params.permit! }

    it 'return new task in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      post :create, params: params
      expect(parse_json(response.body)).to eq(parse_json(Task.last.to_json))
      expect(Task.find_by_id(Task.last.id)).to eq(Task.last)
      expect((Notification.where(task_id: Task.last.id)).count).to eq(1)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    it 'return error with status 403 if customer authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in customer
      post :create, params: params
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PUT update action' do
    let!(:task_2)   { create(:task, stage_id: stage.id, user_id: customer.id, created_by: admin.id) }
    let!(:params)   { ActionController::Parameters.new({ task: { title: "New Task", stage_id: stage.id, priority: "high", due_date: DateTime.now }}) }
    let!(:params_2) { ActionController::Parameters.new({ 'id': task_2.id}) }
    let!(:params_3) { ActionController::Parameters.new({ 'id': tasks_2.first.id}) }

    before { params.permit! }
    before { params_2.permit! }
    before { params_3.permit! }

    it 'return updated task in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      put :update, params: params.merge(params_2)
      task_2.reload
      expect(parse_json(response.body)).to eq(parse_json(task_2.to_json))
      expect(task_2.title).to eq('New Task')
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

    it 'return error with status 403 if customer authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in customer
      put :update, params: params.merge(params_3)
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PUT mark_task_as_completed action' do
    let!(:task_2)  { create(:task, stage_id: stage.id, status: 0, user_id: customer.id, created_by: admin.id) }
    let!(:params)  { ActionController::Parameters.new({'id': task_2.id}) }
    let!(:params_2) { ActionController::Parameters.new({ 'id': tasks_2.first.id}) }

    before { params.permit! }
    before { params_2.permit! }

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
      put :mark_task_as_completed, params: params_2
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return updated task status to completed in json format with status success if customer authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in customer
      put :mark_task_as_completed, params: params
      task_2.reload
      expect(parse_json(response.body)).to eq(parse_json({new_task_status: task_2.status}.to_json))
      expect(task_2.status).to eq('completed')
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if task doesnt belong to customer' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      put :mark_task_as_completed, params: params_2
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE destroy action' do
    let!(:task_3)    { create(:task, stage_id: stage.id, user_id: customer.id, created_by: admin.id) }
    let!(:params)  { ActionController::Parameters.new({'id': task_3.id}) }
    let!(:params_2) { ActionController::Parameters.new({ 'id': tasks_2.first.id}) }

    before { params.permit! }
    before { params_2.permit! }

    it 'return successfully message in json' do
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

    it 'return error with status 403 if customer authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in customer
      post :create, params: params
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end
end
