require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_user!).and_return("skip_authenticate")
    Rails.application.routes.draw do
      post 'api/application', to: 'application#check_auth', as: "check_auth"
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
        user = User.find_for_database_authentication(
          email: params[:user][:email]
        )
        if user&.valid_password?(params[:user][:password]) && user.accelerator_id == accelerator_id
          render json: "success login"
        else
          render json: "faild login"
        end
      end
    end
  end

  describe "check authenticate of user" do
    include_context "a dynamic method"
    it 'return success message if accelerator_id belongs to user and params are valid' do
      params = ActionController::Parameters.new({ user: { email: user.email, password: user.password }})
      params.permit!
      create_method_application_controller
      allow_any_instance_of(ApplicationController).to receive(:accelerator_id).and_return(accelerator.id)
      post :check_auth, params: params
      expect(response.body).to eq("success login")
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'return success message if accelerator_id doesnt belong to user or params arent valid' do
      params = ActionController::Parameters.new({ user: { email: user.email, password: user.password }})
      params.permit!
      create_method_application_controller
      allow_any_instance_of(ApplicationController).to receive(:accelerator_id).and_return(rand(1..600))
      post :check_auth, params: params
      expect(response.body).to eq("faild login")
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end
end
