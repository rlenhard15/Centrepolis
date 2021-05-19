require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:set_category) }
  it { should use_before_action(:set_startup) }

  let!(:accelerator)      { create(:accelerator) }
  let!(:accelerator_2)    { create(:accelerator) }
  let!(:super_admin)      { create(:super_admin) }
  let!(:admin)            { create(:admin, accelerator_id: accelerator.id) }
    let!(:startup_1)      { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
  let!(:admin_2)          { create(:admin, accelerator_id: accelerator.id) }
    let!(:startup_2)      { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin_2.id}]) }
      let!(:startup_admin){ create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup_1.id) }
      let!(:member)       { create(:member, startup_id: startup_1.id, accelerator_id: accelerator.id) }
      let!(:member_2)     { create(:member, startup_id: startup_2.id, accelerator_id: accelerator.id) }
  let!(:assessment)       { create(:assessment) }
    let!(:categories)     { create_list(:category, 4, assessment_id: assessment.id) }
      let!(:sub_category) { create(:sub_category, category_id: categories.first.id) }
        let!(:stage)      { create(:stage, sub_category_id: sub_category.id) }
  let!(:params)           { ActionController::Parameters.new({'assessment_id': assessment.id}) }
  let!(:params_2)         { ActionController::Parameters.new({'id': categories.first.id, 'startup_id': startup_1.id}) }
  let!(:params_3)         { ActionController::Parameters.new({'id': categories.first.id, 'startup_id': startup_2.id}) }

  before do
    params.permit!
    params_2.permit!
    params_3.permit!
  end

  describe 'GET index action' do
    it 'return all categories in json format with status success if member authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      get :index, params: params
      expect(parse_json(response.body).count).to eq(Category.count)
      expect(parse_json(response.body)).to eq(parse_json(Category.for_assessment(assessment.id).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return all categories in json format with status success if startup_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      get :index, params: params
      expect(parse_json(response.body).count).to eq(Category.count)
      expect(parse_json(response.body)).to eq(parse_json(Category.for_assessment(assessment.id).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return all categories in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      get :index, params: params
      expect(parse_json(response.body).count).to eq(Category.count)
      expect(parse_json(response.body)).to eq(parse_json(Category.for_assessment(assessment.id).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return all categories in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      get :index, params: params
      expect(parse_json(response.body).count).to eq(Category.count)
      expect(parse_json(response.body)).to eq(parse_json(Category.for_assessment(assessment.id).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET show action' do
    it 'return category with sub_categories progresses in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      get :show, params: params.merge(params_2)
      expect(parse_json(response.body)).to eq(parse_json(categories.first.as_json.merge(
        sub_categories: categories.first.sub_categories_with_statuses(params[:startup_id].to_i)).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if a super_admin try to get info about startup tha isnt located on the accelerator' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator_2.id}"})
      sign_in super_admin
      get :show, params: params.merge(params_2)
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return category with sub_categories progresses in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      get :show, params: params.merge(params_2)
      expect(parse_json(response.body)).to eq(parse_json(categories.first.as_json.merge(
        sub_categories: categories.first.sub_categories_with_statuses(params[:customer_id].to_i)).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if startup doesnt belong to admin' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      get :show, params: params.merge(params_3)
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end

    it 'return category with sub_categories progresses in json format with status success if startup_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in startup_admin
      get :show, params: params.merge(params_2)
      expect(parse_json(response.body)).to eq(parse_json(categories.first.as_json.merge(
        sub_categories: categories.first.sub_categories_with_statuses(startup_admin.startup_id)).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return category with sub_categories progresses in json format with status success if member authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      get :show, params: params.merge(params_2)
      expect(parse_json(response.body)).to eq(parse_json(categories.first.as_json.merge(
        sub_categories: categories.first.sub_categories_with_statuses(member.startup_id)).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end
  end
end
