require 'rails_helper'

RSpec.describe SubCategoriesController, type: :controller do
  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:authorize_user!) }
  it { should use_before_action(:check_customer) }
  it { should use_before_action(:set_sub_category_progress) }
  it { should use_before_action(:set_assessment) }
  it { should use_before_action(:set_assessment_progress) }

  let!(:accelerator)                   { create(:accelerator) }
  let!(:admin)                         { create(:admin, accelerator_id: accelerator.id) }
  let!(:admin_2)                       { create(:admin, accelerator_id: accelerator.id) }
    let!(:customer)                    { create(:customer, created_by: admin.id, accelerator_id: accelerator.id) }
    let!(:customer_2)                  { create(:customer, created_by: admin_2.id, accelerator_id: accelerator.id) }
  let!(:assessment)                    { create(:assessment) }
    let!(:category)                    { create(:category, assessment_id: assessment.id) }
      let!(:sub_category)              { create(:sub_category, category_id: category.id) }
        let!(:stage)                   { create(:stage, position: 1, sub_category_id: sub_category.id) }
        let!(:stage_2)                 { create(:stage, position: 2, sub_category_id: sub_category.id) }
          let!(:sub_category_progress) { create(:sub_category_progress, customer_id: customer.id, sub_category_id: sub_category.id, current_stage_id: stage.id) }
          let!(:assessment_progress)   { create(:assessment_progress, customer_id: customer.id, assessment_id: assessment.id, risk_value: 60) }

    let!(:params)   { ActionController::Parameters.new({'assessment_id': assessment.id, 'category_id': category.id, 'id': sub_category.id, current_stage_id: stage.id, customer_id: customer.id}) }
    let!(:params_2) { ActionController::Parameters.new({customer_id: customer_2.id}) }

    before { params.permit! }
    before { params_2.permit! }

    describe "POST update_progress action" do
      let!(:params_3)   { ActionController::Parameters.new({current_stage_id: stage_2.id, risk_value: 100}) }
      let!(:params_4)   { ActionController::Parameters.new({customer_id: customer.id}) }

      before { params_3.permit! }
      before { params_4.permit! }

      it "return success messege and risk_value" do
        request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
        sign_in admin
        post :update_progress, params: params.merge(params_3).merge(params_4)
        sub_category_progress.reload
        assessment_progress.reload
        expect(response.body).to eq({ message: "Progress updates successfully", assessment_risk: assessment_progress.risk_value.to_f }.to_json)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(sub_category_progress.current_stage_id).to eq(stage_2.id)
        expect(assessment_progress.risk_value).to eq(100)
        expect(response).to have_http_status(:success)
      end

      it "return error in json with status forbidden if admin try to update progress not for his customer" do
        request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
        sign_in admin
        post :update_progress, params: params.merge(params_2)
        expect(response.body).to eq({'notice': 'You do not have permission to perform this action'}.to_json)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:forbidden)
      end

      it "return success messege and risk_value for current customer" do
        request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
        sign_in customer
        post :update_progress, params: params.merge(params_3)
        sub_category_progress.reload
        assessment_progress.reload
        expect(response.body).to eq({ message: "Progress updates successfully", assessment_risk: assessment_progress.risk_value.to_f }.to_json)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(sub_category_progress.current_stage_id).to eq(stage_2.id)
        expect(assessment_progress.risk_value).to eq(100)
        expect(response).to have_http_status(:success)
      end

      it "if there is customer_id and customer try to update progress with this id, its only update his progress" do
        request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
        sign_in customer
        post :update_progress, params: params.merge(params_2).merge(params_3)
        sub_category_progress.reload
        assessment_progress.reload
        expect(response.body).to eq({ message: "Progress updates successfully", assessment_risk: assessment_progress.risk_value.to_f }.to_json)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(sub_category_progress.customer_id).to eq(customer.id)
        expect(SubCategoryProgress.find_by_customer_id(customer_2.id)).to eq(nil)
        expect(sub_category_progress.current_stage_id).to eq(stage_2.id)
        expect(assessment_progress.risk_value).to eq(100)
        expect(response).to have_http_status(:success)
      end
    end
end
