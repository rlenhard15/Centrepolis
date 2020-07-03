require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:set_category) }
  it { should use_before_action(:set_customer) }

  let!(:accelerator)      { create(:accelerator) }
  let!(:admin)            { create(:admin, accelerator_id: accelerator.id) }
    let!(:customer)       { create(:customer, created_by: admin.id, accelerator_id: accelerator.id) }
  let!(:assessment)       { create(:assessment) }
    let!(:categories)     { create_list(:category, 4, assessment_id: assessment.id) }
      let!(:sub_category) { create(:sub_category, category_id: categories.first.id) }
        let!(:stage)      { create(:stage, sub_category_id: sub_category.id) }
  let!(:params)           { ActionController::Parameters.new({'assessment_id': assessment.id}) }
  let!(:params_2)         { ActionController::Parameters.new({'id': categories.first.id, 'customer_id': customer.id}) }

  before do
    params.permit!
    params_2.permit!
  end

  describe 'GET index action' do
    it 'return all categories in json format with status success if customer authenticated' do
      sign_in customer
      get :index, params: params
      expect(parse_json(response.body).count).to eq(Category.count)
      expect(parse_json(response.body)).to eq(parse_json(Category.for_assessment(assessment.id).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return all categories in json format with status success if admin authenticated' do
      sign_in admin
      get :index, params: params
      expect(parse_json(response.body).count).to eq(Category.count)
      expect(parse_json(response.body)).to eq(parse_json(Category.for_assessment(assessment.id).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET show action' do
    it 'return category with sub_categories progresses in json format with status success if admin authenticated' do
      sign_in admin
      get :show, params: params.merge(params_2)
      expect(parse_json(response.body)).to eq(parse_json(categories.first.as_json.merge(
        sub_categories: categories.first.sub_categories_with_statuses(params[:customer_id].to_i)).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return category with sub_categories progresses in json format with status success if customer authenticated' do
      sign_in customer
      get :show, params: params.merge(params_2)
      expect(parse_json(response.body)).to eq(parse_json(categories.first.as_json.merge(
        sub_categories: categories.first.sub_categories_with_statuses(params[:customer_id].to_i)).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end
  end
end
