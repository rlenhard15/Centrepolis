require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Associations" do
    it { should have_many(:task_users).dependent(:destroy) }
    it { should have_many(:tasks).through(:task_users) }
    it { should have_many(:notifications).dependent(:destroy) }
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
            "accelerator_id"=> accelerator.id,
            "startup_id"=> user.startup_id,
            "email_notification"=> user.email_notification,
            "phone_number"=> user.phone_number
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
            "accelerator_id"=> accelerator.id,
            "startup_id"=> user.startup_id,
            "email_notification"=> user.email_notification,
            "phone_number"=> user.phone_number
          },
          :user_type => "Admin"
        }
      )
    end
  end

  describe "Method 'super_admin?'" do
    let!(:accelerator)   { create(:accelerator) }
    let!(:super_admin)   { create(:user, type:'SuperAdmin') }
    let!(:admin)         { create(:user, type:'Admin', accelerator_id: accelerator.id) }
      let!(:startup)     { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
    let!(:startup_admin) { create(:user, type:'StartupAdmin', accelerator_id: accelerator.id, startup_id: startup.id) }
    let!(:member)        { create(:user, type:'Member', accelerator_id: accelerator.id, startup_id: startup.id) }

    it "return true if user's type 'SuperAdmin'" do
      expect(super_admin.super_admin?).to eq(true)
    end

    it "return false if user's type isn't 'SuperAdmin'" do
      expect(admin.super_admin?).to eq(false)
    end

    it "return false if user's type isn't 'SuperAdmin'" do
      expect(startup_admin.super_admin?).to eq(false)
    end

    it "return false if user's type isn't 'SuperAdmin'" do
      expect(member.super_admin?).to eq(false)
    end
  end

  describe "Method 'admin?'" do
    let!(:accelerator)   { create(:accelerator) }
    let!(:super_admin)   { create(:user, type:'SuperAdmin') }
    let!(:admin)         { create(:user, type:'Admin', accelerator_id: accelerator.id) }
      let!(:startup)     { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
    let!(:startup_admin) { create(:user, type:'StartupAdmin', accelerator_id: accelerator.id, startup_id: startup.id) }
    let!(:member)        { create(:user, type:'Member', accelerator_id: accelerator.id, startup_id: startup.id) }

    it "return true if user's type 'Admin'" do
      expect(admin.admin?).to eq(true)
    end

    it "return false if user's type isn't 'Admin'" do
      expect(super_admin.admin?).to eq(false)
    end

    it "return false if user's type isn't 'Admin'" do
      expect(startup_admin.admin?).to eq(false)
    end

    it "return false if user's type isn't 'Admin'" do
      expect(member.admin?).to eq(false)
    end
  end

  describe "Method 'startup_admin?'" do
    let!(:accelerator)   { create(:accelerator) }
    let!(:super_admin)   { create(:user, type:'SuperAdmin') }
    let!(:admin)         { create(:user, type:'Admin', accelerator_id: accelerator.id) }
      let!(:startup)     { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
    let!(:startup_admin) { create(:user, type:'StartupAdmin', accelerator_id: accelerator.id, startup_id: startup.id) }
    let!(:member)        { create(:user, type:'Member', accelerator_id: accelerator.id, startup_id: startup.id) }

    it "return true if user's type 'StartupAdmin'" do
      expect(startup_admin.startup_admin?).to eq(true)
    end

    it "return false if user's type isn't 'StartupAdmin'" do
      expect(super_admin.startup_admin?).to eq(false)
    end

    it "return false if user's type isn't 'StartupAdmin'" do
      expect(admin.startup_admin?).to eq(false)
    end

    it "return false if user's type isn't 'StartupAdmin'" do
      expect(member.startup_admin?).to eq(false)
    end
  end

    describe "Method 'member?'" do
      let!(:accelerator)   { create(:accelerator) }
      let!(:super_admin)   { create(:user, type:'SuperAdmin') }
      let!(:admin)         { create(:user, type:'Admin', accelerator_id: accelerator.id) }
        let!(:startup)     { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
      let!(:startup_admin) { create(:user, type:'StartupAdmin', accelerator_id: accelerator.id, startup_id: startup.id) }
      let!(:member)        { create(:user, type:'Member', accelerator_id: accelerator.id, startup_id: startup.id) }

      it "return true if user's type 'Member'" do
        expect(member.member?).to eq(true)
      end

      it "return false if user's type isn't 'Member'" do
        expect(super_admin.member?).to eq(false)
      end

      it "return false if user's type isn't 'Member'" do
        expect(admin.member?).to eq(false)
      end

      it "return false if user's type isn't 'Member'" do
        expect(startup_admin.member?).to eq(false)
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

  describe "Methods for select users with specific type" do
    let!(:accelerator)   { create(:accelerator) }
    let!(:super_admin)   { create(:super_admin) }
    let!(:admins)        { create_list(:admin, 3, accelerator_id: accelerator.id) }
      let!(:startup)     { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.first.id}]) }
    let!(:startup_admins){ create_list(:startup_admin, 4, accelerator_id: accelerator.id, startup_id: startup.id) }
    let!(:members)       { create_list(:member, 2, accelerator_id: accelerator.id, startup_id: startup.id) }

    it "Scope 'members' return all members" do
      members_info = User.members.order(created_at: :asc).as_json

      recursively_delete_timestamps(members_info)

      expect(members_info.count).to eq(2)
      expect(members_info[0]).to eq(
        {
          "id"=> members.first.id,
          "email"=> members.first.email,
          "first_name"=> members.first.first_name,
          "last_name"=> members.first.last_name,
          "accelerator_id"=> members.first.accelerator_id,
          "startup_id"=> members.first.startup_id,
          "email_notification"=> members.first.email_notification,
          "phone_number"=> members.first.phone_number
        }
      )
    end

    it "Scope 'admins' return all admins" do
      admins_info = User.admins.order(created_at: :asc).as_json

      recursively_delete_timestamps(admins_info)

      expect(admins_info.count).to eq(3)
      expect(admins_info[0]).to eq(
        {
          "id"=> admins.first.id,
          "email"=> admins.first.email,
          "first_name"=> admins.first.first_name,
          "last_name"=> admins.first.last_name,
          "accelerator_id"=> admins.first.accelerator_id,
          "startup_id"=> admins.first.startup_id,
          "email_notification"=> admins.first.email_notification,
          "phone_number"=> admins.first.phone_number
        }
      )
    end

    it "Scope 'startup_admins' return all startup_admins" do
      startup_admins_info = User.startup_admins.order(created_at: :asc).as_json

      recursively_delete_timestamps(startup_admins_info)

      expect(startup_admins_info.count).to eq(4)
      expect(startup_admins_info[0]).to eq(
        {
          "id"=> startup_admins.first.id,
          "email"=> startup_admins.first.email,
          "first_name"=> startup_admins.first.first_name,
          "last_name"=> startup_admins.first.last_name,
          "accelerator_id"=> startup_admins.first.accelerator_id,
          "startup_id"=> startup_admins.first.startup_id,
          "email_notification"=> startup_admins.first.email_notification,
          "phone_number"=> startup_admins.first.phone_number
        }
      )
    end
  end
end
