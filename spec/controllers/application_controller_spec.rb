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

  let!(:user) { create(:user) }

  shared_examples "a dynamic method" do |method_name = "check_auth"|
    let(:create_method_application_controller) do
      ApplicationController.define_method(method_name) do
        response_auth =  (current_user.present?)? "success login" : "faild login"
        render json: response_auth.to_json
      end
    end
  end

  describe "check authenticate of user" do
    include_context "a dynamic method"
    it 'return success message' do
      create_method_application_controller
      sign_in user
      get :check_auth
      expect(JSON.parse(response.body)).to eq("success login")
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end
end
