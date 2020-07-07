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
      ApplicationController.define_method(method_name) do
        render json: "succed!"
      end
    end
  end

  describe "check authenticate of user" do
    include_context "a dynamic method"
    let!(:auth_token) { JwtWrapper.encode(user_id: user.id) }

    it 'return success message if accelerator_id belongs to user' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id}", "Authentication": "Bearer #{auth_token}" })
      sign_in user
      create_method_application_controller
      get :check_auth
      expect(response.body).to eq("succed!")
      expect(response.status).to eq(200)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'return faild login message if accelerator_id doesnt belong to user' do
      request.headers.merge!({ "Accelerator-Id": "#{accelerator.id + 1}", "Authentication": "Bearer #{auth_token}" })
      sign_in user
      create_method_application_controller
      get :check_auth
      expect(response.body).to eq("You need to sign in or sign up before continuing.")
      expect(response.status).to eq(401)
      expect(response.content_type).to eq('text/html; charset=utf-8')
    end
  end
end
