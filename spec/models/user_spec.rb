require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    let!(:user_1) { create(:user, email: "example@gmail.com", password: "qwerty") }

    it "is valid with valid attributes" do
      expect(user_1).to be_valid
    end

    it "is not valid without a password or email" do
      user_1.password = nil || user_1.email = nil
      expect(user_1).to_not be_valid
    end

    context 'when email is unique' do
      it "is not valid without uniq email" do
        expect(User.new(email: "example@gmail.com", password: "qwerty")).to_not be_valid
      end
    end
  end

  describe "Method 'payload'" do
    let!(:user)       {create(:user, email: "test_user@gmail.com")}
    let!(:auth_token) {JwtWrapper.encode(user_id: user.id)}

    it 'return user`s auth_token and email' do
      payload = user.payload
      payload[:user].delete('created_at')
      payload[:user].delete('updated_at')
      payload[:user].delete('id')

      expect(payload).to eq(
        {:auth_token => "#{auth_token}",
          :user=>{
            "email"=>"test_user@gmail.com"
          }
        }
      )
    end
  end

  describe "Method 'user_info'" do
    let!(:user) { create(:user, email: "test_user@gmail.com") }

    it "return email of user" do
      user_info = user.user_info
      user_info[:user].delete('created_at')
      user_info[:user].delete('updated_at')
      user_info[:user].delete('id')

      expect(user_info).to eq(
        {
          :user=>{
            "email"=>"test_user@gmail.com"
          }
        }
      )
    end
  end

  describe "Associations" do
    it { should have_many(:tasks).dependent(:destroy) }
  end
end
