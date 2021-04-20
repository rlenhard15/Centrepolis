require 'rails_helper'

RSpec.describe StartupPolicy, type: :policy do
  subject { described_class.new(user, startup) }

  let(:policy_scope) do
    described_class::Scope.new(user, Startup.all).resolve
  end

  let!(:accelerator)      { create(:accelerator) }
  let!(:accelerator_2)    { create(:accelerator) }
  let!(:super_admin)      { create(:super_admin, accelerator_id: accelerator.id) }
  let!(:super_admin_2)    { create(:super_admin, accelerator_id: accelerator_2.id) }
  let!(:admin)            {create(:admin, accelerator_id: accelerator.id)}
  let!(:admin_2)          {create(:admin, accelerator_id: accelerator_2.id)}
  let!(:startup)          { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
    let!(:startup_admin)  { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup.id) }
    let!(:member)         { create(:member, accelerator_id: accelerator.id, startup_id: startup.id) }

  describe "user's type: SuperAdmin" do
    let!(:accelerator) { create(:accelerator) }
    let!(:user)        { create(:super_admin, accelerator_id: accelerator.id) }

    it "show startups for current super_admin" do
      expect(policy_scope).to eq(Startup.where(accelerator_id: super_admin.accelerator_id))
    end

    it { is_expected.to permit_actions(%i[create]) }
  end

  describe "user's type: Admin" do
    let!(:accelerator) { create(:accelerator) }
    let!(:user)        { admin }

    it "show startups for current admin" do
      expect(policy_scope).to eq(admin.startups)
    end

    it { is_expected.to permit_actions(%i[create]) }
  end

  describe "user's type: StartupAdmin" do
    let!(:accelerator) { create(:accelerator) }
    let!(:user)        { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup.id) }

    it "show startups for current startup_admin" do
      expect(policy_scope).to eq(startup_admin.startup)
    end

    it { is_expected.to forbid_actions(%i[create]) }
  end

  describe "user's type: Member" do
    let!(:accelerator) { create(:accelerator) }
    let!(:user)        { create(:member, accelerator_id: accelerator.id, startup_id: startup.id) }

    it "show startups for current member" do
      expect(policy_scope).to eq(member.startup)
    end

    it { is_expected.to forbid_actions(%i[create]) }
  end
end
