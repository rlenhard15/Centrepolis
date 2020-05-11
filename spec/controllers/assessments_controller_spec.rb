require 'rails_helper'

RSpec.describe AssessmentsController, type: :controller do
  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:set_customer) }
  it { should use_before_action(:set_assessment) }

  let!(:admin)                { create(:admin) }
  let!(:admin_2)              { create(:admin) }
    let!(:customer)           { create(:customer, created_by: admin.id) }
    let!(:customer_2)         { create(:customer, created_by: admin_2.id) }
  let!(:assessments)          { create_list(:assessment, 2) }
    let!(:assessment_progress){ create(:assessment_progress, customer_id: customer.id, assessment_id: assessments.first.id) }
    let!(:categories)         { create_list(:category, 2, assessment_id: assessments.first.id) }
      let!(:sub_category_1)   { create(:sub_category, category_id: categories.first.id) }
      let!(:sub_category_2)   { create(:sub_category, category_id: categories.last.id) }

    let!(:params)             { ActionController::Parameters.new({'id': assessments.first.id}) }
    let!(:params_2)           { ActionController::Parameters.new({'customer_id': customer.id}) }
    let!(:params_3)           { ActionController::Parameters.new({'customer_id': customer_2.id}) }

    before { params.permit! }
    before { params_2.permit! }
    before { params_3.permit! }

  describe 'GET index action' do
    it 'return all assessments with risk_value for current customer in json format with status success if customer authenticated' do
      sign_in customer
      get :index
      expect(parse_json(response.body).count).to eq(Assessment.count)
      expect(parse_json(response.body)).to eq(parse_json(Assessment.with_assessment_progresses(customer.id).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return all assessments with risk_value for current admin in json format with status success if admin authenticated' do
      sign_in admin
      get :index, params: params_2
      expect(parse_json(response.body).count).to eq(Assessment.count)
      expect(parse_json(response.body)).to eq(parse_json(Assessment.with_assessment_progresses(customer.id).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return error with status 403 if customer doesnt belong to admin' do
      sign_in admin
      get :index, params: params_3
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'GET show action' do
    it 'return specific assessment with child models in json format with status success if customer authenticated' do
      sign_in customer
      get :show, params: params
      expect(parse_json(response.body)).to eq(parse_json(assessments.first.as_json(methods: :description_with_child_models).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return specific assessment with child models in json format with status success if admin authenticated' do
      sign_in admin
      get :show, params: params
      expect(parse_json(response.body)).to eq(parse_json(assessments.first.as_json(methods: :description_with_child_models).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end
  end
end
