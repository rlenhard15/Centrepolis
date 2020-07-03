require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  before do
    Rails.application.routes.draw do
      get 'api/application', to: 'application#check_auth', as: "check_auth"
    end
  end
  after do
    Rails.application.reload_routes!
  end

  let!(:accelerator) { create(:accelerator) }
  let!(:user)        { create(:user, accelerator_id: accelerator.id) }

  shared_examples "a dynamic method" do |method_name = "check_auth"|

    let(:create_method_application_controller) do
      ApplicationController.define_method(:accelerator_id) do
        accelerator_id = request.headers['Accelerator-Id'].to_i
      end
      ApplicationController.define_method(method_name) do
        response_auth =  ((current_user.present?)  && current_user.accelerator_id == accelerator_id) ?  "success login" : "faild login"
        render json: response_auth.to_json
      end
    end
  end

  describe "check authenticate of user" do
    include_context "a dynamic method"
    it 'return success message if accelerator_id belongs to user' do
      create_method_application_controller
      allow_any_instance_of(ApplicationController).to receive(:accelerator_id).and_return(accelerator.id)
      sign_in user
      get :check_auth
      expect(JSON.parse(response.body)).to eq("success login")
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'return faild login message if accelerator_id doesnnt belong to user' do
      create_method_application_controller
      allow_any_instance_of(ApplicationController).to receive(:accelerator_id).and_return(rand(1..600))
      sign_in user
      get :check_auth
      expect(JSON.parse(response.body)).to eq("faild login")
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end
end
