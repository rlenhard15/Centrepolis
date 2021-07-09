require 'rails_helper'

RSpec.describe StagesController, type: :controller do
  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:set_sub_category) }

  let!(:accelerator)       { create(:accelerator) }
  let!(:super_admin)       { create(:super_admin) }
  let!(:admin)             { create(:admin, accelerator_id: accelerator.id) }
    let!(:startup)         { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
      let!(:team_lead)     { create(:team_lead, accelerator_id: accelerator.id, startup_id: startup.id) }
      let!(:member)        { create(:member, startup_id: startup.id, accelerator_id: accelerator.id) }
  let!(:assessment)        { create(:assessment) }
  let!(:category)          { create(:category, assessment_id: assessment.id) }
    let!(:sub_category)    { create(:sub_category, category_id: category.id) }
      let!(:stage_1)       { create(:stage, sub_category_id: sub_category.id) }
      let!(:stage_2)       { create(:stage, sub_category_id: sub_category.id) }

  let!(:params)          { ActionController::Parameters.new({'assessment_id': assessment.id, 'category_id': category.id, 'sub_category_id': sub_category.id}) }

  before { params.permit! }

  describe 'GET index action' do
    it 'return all stages in json format with status success if super_admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in super_admin
      get :index, params: params
      expect(parse_json(response.body).count).to eq(Stage.count)
      expect(parse_json(response.body)).to eq(parse_json([stage_1, stage_2].as_json(include: :tasks).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return all stages in json format with status success if admin authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in admin
      get :index, params: params
      expect(parse_json(response.body).count).to eq(Stage.count)
      expect(parse_json(response.body)).to eq(parse_json([stage_1, stage_2].as_json(include: :tasks).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return all stages in json format with status success if team_lead authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in team_lead
      get :index, params: params
      expect(parse_json(response.body).count).to eq(Stage.count)
      expect(parse_json(response.body)).to eq(parse_json([stage_1, stage_2].as_json(include: :tasks).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'return all stages in json format with status success if member authenticated' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}"})
      sign_in member
      get :index, params: params
      expect(parse_json(response.body).count).to eq(Stage.count)
      expect(parse_json(response.body)).to eq(parse_json([stage_1, stage_2].as_json(include: :tasks).to_json))
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end
  end
end
