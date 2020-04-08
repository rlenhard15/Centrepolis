require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Associations" do
    it { should have_many(:tasks).dependent(:destroy) }
  end

  describe "Method 'payload'" do
    let!(:user)       { create(:admin, email: "test_user@gmail.com") }
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
            "created_by"=> user.created_by
          },
          :user_type => "Admin"
        }
      )
    end
  end

  describe "Method 'user_info'" do
    let!(:user) { create(:admin, email: "test_user@gmail.com") }

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
            "created_by"=> user.created_by
          },
          :user_type => "Admin"
        }
      )
    end
  end

  describe "Method 'admin?'" do
    let!(:admin)    { create(:user, type:'Admin') }
    let!(:customer) { create(:user, type:'Customer') }

    it "return true if user's type 'Admin'" do
      expect(admin.admin?).to eq(true)
    end

    it "return false if user's type isn't 'Admin'" do
      expect(customer.admin?).to eq(false)
    end
  end

  describe "Method 'customer?'" do
    let!(:admin)    { create(:user, type:'Admin') }
    let!(:customer) { create(:user, type:'Customer') }

    it "return true if user's type 'Customer'" do
      expect(customer.customer?).to eq(true)
    end

    it "return false if user's type isn't 'Customer'" do
      expect(admin.customer?).to eq(false)
    end
  end
end
