require 'rails_helper'

RSpec.describe StagesController, type: :controller do
  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:set_sub_category) }

  let!(:assessment)      { create(:assessment) }
    let!(:category)      { create(:category, assessment_id: assessment.id) }
      let!(:sub_category){ create(:sub_category, category_id: category.id) }
        let!(:stage_1)   { create(:stage, sub_category_id: sub_category.id) }
        let!(:stage_2)   { create(:stage, sub_category_id: sub_category.id, position: 2) }
  let!(:accelerator)     { create(:accelerator) }
  let!(:admin)           { create(:admin, accelerator_id: accelerator.id) }
    let!(:customer)      { create(:customer, created_by: admin.id, accelerator_id: accelerator.id) }
  let!(:params)          { ActionController::Parameters.new({'assessment_id': assessment.id, 'category_id': category.id, 'sub_category_id': sub_category.id}) }

  before { params.permit! }

  describe 'GET index action' do
    it 'return all stages in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      get :index, params: params
      expect(parse_json(response.body).count).to eq(Stage.count)
      expect(parse_json(response.body)).to eq(parse_json([stage_1, stage_2].as_json(include: :tasks).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return all stages in json format with status success if customer authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in customer
      get :index, params: params
      expect(parse_json(response.body).count).to eq(Stage.count)
      expect(parse_json(response.body)).to eq(parse_json([stage_1, stage_2].as_json(include: :tasks).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end
  end
end
