require 'rails_helper'

RSpec.describe Admins::CustomersController, type: :controller do
  it { should use_before_action(:authenticate_user!) }

  let!(:accelerator)           { create(:accelerator) }
  let!(:admin)                 { create(:admin, accelerator_id: accelerator.id) }
    let!(:customers)           { create_list(:customer, 2, created_by: admin.id, accelerator_id: accelerator.id) }
  let!(:assessment)            { create(:assessment) }
    let!(:assessment_progress) { create(:assessment_progress, customer_id: customers.first.id, assessment_id: assessment.id) }
    let!(:category)            { create(:category, assessment_id: assessment.id) }
      let!(:sub_category)      { create(:sub_category, category_id: category.id) }
        let!(:stage)           { create(:stage, sub_category_id: sub_category.id) }

  describe "GET index action" do
    it "return customers with list of assessment_risk for current admin" do
      sign_in admin
      get :index
      expect(parse_json(response.body).count).to eq(2)
      expect(parse_json(response.body)).to eq(admin.customers.as_json(methods: :assessments_risk_list, except: [:created_at, :updated_at]))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it "return error in json with status forbidden if sign in as customer" do
      sign_in customers.first
      get :index
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST create action" do
    let!(:params) {ActionController::Parameters.new({customer: {email: 'customer@gmail.com', company_name: 'Company name', accelerator_id: accelerator.id}})}

    before {params.permit!}

    it "return customer who was created by admin" do
      sign_in admin
      post :create, params: params
      expect(parse_json(response.body)).to eq(parse_json(Customer.last.to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    it "return error in json with status forbidden if sign in as customer" do
      sign_in customers.first
      post :create, params: params
      expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:forbidden)
    end
  end
end
