require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Associations" do
    it { should have_many(:tasks).dependent(:destroy) }
    it { should belong_to(:accelerator) }
  end

  describe "Method 'payload'" do
    let!(:accelerator){ create(:accelerator) }
    let!(:user)       { create(:admin, email: "test_user@gmail.com", accelerator_id: accelerator.id) }
    let!(:auth_token) { JwtWrapper.encode(user_id: user.id) }

    it 'return user`s auth_token and email' do
      payload = user.payload
      payload[:user].delete('created_at')
      payload[:user].delete('updated_at')

      expect(payload).to eq(
        { auth_token: auth_token,
          user: {
            "id"=> user.id,
            "email"=> "test_user@gmail.com",
            "first_name"=> user.first_name,
            "last_name"=> user.last_name,
            "company_name"=> user.company_name,
            "created_by"=> user.created_by,
            "accelerator_id"=> accelerator.id
          },
          :user_type => "Admin"
        }
      )
    end
  end

  describe "Method 'user_info'" do
    let!(:accelerator) { create(:accelerator) }
    let!(:user)        { create(:admin, email: "test_user@gmail.com", accelerator_id: accelerator.id) }

    it "return email of user" do
      user_info = user.user_info
      user_info[:user].delete('created_at')
      user_info[:user].delete('updated_at')

      expect(user_info).to eq(
        {
          user: {
            "id"=> user.id,
            "email"=> "test_user@gmail.com",
            "first_name"=> user.first_name,
            "last_name"=> user.last_name,
            "company_name"=> user.company_name,
            "created_by"=> user.created_by,
            "accelerator_id"=> accelerator.id
          },
          :user_type => "Admin"
        }
      )
    end
  end

  describe "Method 'super_admin?'" do
    let!(:accelerator) { create(:accelerator) }
      let!(:super_admin) { create(:user, type:'SuperAdmin',  accelerator_id: accelerator.id) }
      let!(:admin)       { create(:user, type:'Admin',  accelerator_id: accelerator.id) }
      let!(:customer)    { create(:user, type:'Customer',  accelerator_id: accelerator.id) }

    it "return true if user's type 'SuperAdmin'" do
      expect(super_admin.super_admin?).to eq(true)
    end

    it "return false if user's type isn't 'SuperAdmin'" do
      expect(admin.super_admin?).to eq(false)
    end

    it "return false if user's type isn't 'SuperAdmin'" do
      expect(customer.super_admin?).to eq(false)
    end
  end

  describe "Method 'admin?'" do
    let!(:accelerator) { create(:accelerator) }
    let!(:admin)       { create(:user, type:'Admin',  accelerator_id: accelerator.id) }
    let!(:customer)    { create(:user, type:'Customer',  accelerator_id: accelerator.id) }

    it "return true if user's type 'Admin'" do
      expect(admin.admin?).to eq(true)
    end

    it "return false if user's type isn't 'Admin'" do
      expect(customer.admin?).to eq(false)
    end
  end

  describe "Method 'customer?'" do
    let!(:accelerator) { create(:accelerator) }
    let!(:admin)       { create(:user, type:'Admin',  accelerator_id: accelerator.id) }
    let!(:customer)    { create(:user, type:'Customer',  accelerator_id: accelerator.id) }

    it "return true if user's type 'Customer'" do
      expect(customer.customer?).to eq(true)
    end

    it "return false if user's type isn't 'Customer'" do
      expect(admin.customer?).to eq(false)
    end
  end

  describe "Method 'set_user_by_password_token'" do
    let!(:accelerator)    { create(:accelerator) }
    let!(:user)           { create(:admin, accelerator_id: accelerator.id) }
    let!(:password_token) { user.send(:set_reset_password_token) }

    it "return user if there is user with current password token" do
      attributes = ActionController::Parameters.new({reset_password_token: password_token, password: "123456", password_confirmation: "123456"})
      attributes.permit!
      set_user = User.set_user_by_password_token(attributes)
      expect(set_user).to eq(user)
    end

    it "return empty instance of user if there isnt user with current password token" do
      attributes = ActionController::Parameters.new({reset_password_token: "password_token", password: "123456", password_confirmation: "123456"})
      attributes.permit!
      set_user = User.set_user_by_password_token(attributes)
      expect([set_user.id, set_user.email]).to eq([nil, ""])
    end
  end

  describe "Method 'reset_password_by_token'" do
    let!(:accelerator)    { create(:accelerator) }
    let!(:user)           { create(:user, accelerator_id: accelerator.id) }
    let!(:password_token) { user.send(:set_reset_password_token) }
    let!(:attributes)     {ActionController::Parameters.new({reset_password_token: password_token, password: "123456", password_confirmation: "123456"})}

    before { attributes.permit! }

    it "return user with updated password" do
      user_after_reset_password = user.reset_password_by_token(attributes)
      expect(user_after_reset_password).to eq(user)
      expect(user_after_reset_password.password).to eq("123456")
    end
  end
end
