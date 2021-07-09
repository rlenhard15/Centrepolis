require 'rails_helper'

RSpec.describe AdminPolicy, type: :policy do
  subject { described_class.new(user, admin) }

  let!(:accelerator)          { create(:accelerator) }
  let!(:accelerator_2)        { create(:accelerator) }
  let!(:super_admin)          { create(:super_admin) }
  let!(:super_admin_2)        { create(:super_admin) }
  let!(:admin)                { create(:admin, accelerator_id: accelerator.id) }
  let!(:admins_2)             { create_list(:admin, 3, accelerator_id: accelerator_2.id) }
  let!(:startup)              { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
  let!(:team_lead)            { create(:team_lead, accelerator_id: accelerator.id, startup_id: startup.id) }
  let!(:member)               { create(:member, startup_id: startup.id, accelerator_id: accelerator.id) }

  let(:policy_scope) do
    described_class::Scope.new(user, Admin.all).resolve
  end

  describe "not auth user" do
    let!(:user)  { nil }

    it "doesn't show any admin" do
      expect(policy_scope).to eq([])
    end
  end

  describe "user's type: SuperAdmin" do
    let!(:user)  { super_admin }

    it "shows admins which of the super_admin accelerator" do
      expect(policy_scope).to eq(Admin.all)
    end

    it { is_expected.to permit_actions(%i[index]) }
  end

  describe "user's type: Admin" do
    let!(:user) { admin }

    it "dont shows list of admins" do
      expect(policy_scope).to eq([])
    end

    it { is_expected.to forbid_actions(%i[index]) }
  end

  describe "user's type: StartupAdmin" do
    let!(:user) { team_lead }

    it "dont shows list of admins" do
      expect(policy_scope).to eq([])
    end

    it { is_expected.to forbid_actions(%i[index]) }
  end

  describe "user's type: Member" do
    let!(:user) { member }

    it "dont shows list of admins" do
      expect(policy_scope).to eq([])
    end

    it { is_expected.to forbid_actions(%i[index]) }
  end
end
