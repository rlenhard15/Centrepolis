require 'rails_helper'

RSpec.describe MemberPolicy, type: :policy do
  subject { described_class.new(user, member) }

  let!(:accelerator)      { create(:accelerator) }
  let!(:super_admin)      { create(:super_admin) }
  let!(:admin)            {create(:admin, accelerator_id: accelerator.id)}
  let!(:startup)          { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
    let!(:team_lead)      {create(:team_lead, accelerator_id: accelerator.id, startup_id: startup.id) }
    let!(:member)         {create(:member, startup_id: startup.id, accelerator_id: accelerator.id)}

  let(:policy_scope) do
    described_class::Scope.new(user, Member.all).resolve
  end

  describe "not auth user" do
    let!(:user)  { nil }

    it "doesn't show any member" do
      expect(policy_scope).to eq([])
    end
  end

  describe "user's type: SuperAdmin" do
    let!(:user)  { super_admin }

    it "shows members wof the accelerator" do
      expect(policy_scope).to eq(Member.all)
    end

    it { is_expected.to permit_actions(%i[index create]) }
  end

  describe "user's type: Admin" do
    let!(:user)  { admin }

    it "shows members which belongs to admins startups" do
      expect(policy_scope).to eq(Member.where(startup_id: user.startup_ids))
    end

    it { is_expected.to permit_actions(%i[index create]) }
  end

  describe "user's type: StartupAdmin" do
    let!(:user)  { team_lead }

    it "shows members which admin created" do
      expect(policy_scope).to eq(Member.where(startup_id: user.startup_id))
    end

    it { is_expected.to permit_actions(%i[index create]) }
  end

  describe "user's type: Member" do
    let!(:user) { create(:member, startup_id: startup.id, accelerator_id: accelerator.id) }

    it "dont shows list of customers" do
      expect(policy_scope).to eq([])
    end

    it { is_expected.to forbid_actions(%i[index create]) }
  end
end
