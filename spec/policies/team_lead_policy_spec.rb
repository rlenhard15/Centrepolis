require 'rails_helper'

RSpec.describe TeamLeadPolicy, type: :policy do
  subject { described_class.new(user, admin) }

  let!(:accelerator)          { create(:accelerator) }
  let!(:accelerator_2)        { create(:accelerator) }
  let!(:super_admin)          { create(:super_admin) }
  let!(:super_admin_2)        { create(:super_admin) }
  let!(:admin)                { create(:admin, accelerator_id: accelerator.id) }
  let!(:admin_2)              { create(:admin, accelerator_id: accelerator.id) }
  let!(:admins_2)             { create_list(:admin, 3, accelerator_id: accelerator_2.id) }
  let!(:startup)              { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
  let!(:startup_2)            { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin_2.id}]) }
  let!(:startup_3)            { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins_2.first.id}]) }
  let!(:team_lead)            { create(:team_lead, accelerator_id: accelerator.id, startup_id: startup_2.id) }
  let!(:team_lead_2)          { create(:team_lead, accelerator_id: accelerator_2.id, startup_id: startup_3.id) }
  let!(:member)               { create(:member, startup_id: startup.id, accelerator_id: accelerator.id) }

  let(:policy_scope) do
    described_class::Scope.new(user, TeamLead.all).resolve
  end

  describe "not auth user" do
    let!(:user)  { nil }

    it "doesn't show any team_lead" do
      expect(policy_scope).to eq([])
    end
  end

  describe "user's type: SuperAdmin" do
    let!(:user)  { super_admin }

    it "shows team_leads which belongs to the super_admin accelerator" do
      expect(policy_scope).to eq(TeamLead.all)
    end

    it { is_expected.to permit_actions(%i[index]) }
  end

  describe "user's type: Admin" do
    let!(:user) { admin }

    it "shows team_leads which belongs to the admins startups" do
      expect(policy_scope).to eq(TeamLead.where(startup_id: user.startup_ids))
    end

    it { is_expected.to permit_actions(%i[index]) }
  end

  describe "user's type: TeamLead" do
    let!(:user) { team_lead }

    it "dont shows list of team_leads" do
      expect(policy_scope).to eq([])
    end

    it { is_expected.to forbid_actions(%i[index]) }
  end

  describe "user's type: Member" do
    let!(:user) { member }

    it "dont shows list of team_leads" do
      expect(policy_scope).to eq([])
    end

    it { is_expected.to forbid_actions(%i[index]) }
  end
end
