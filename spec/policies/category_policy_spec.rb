require 'rails_helper'

RSpec.describe CategoryPolicy, type: :policy do
  subject { described_class.new(user, categories) }

  let(:policy_scope) do
    described_class::Scope.new(user, Category.all).resolve
  end

  let!(:accelerator)        { create(:accelerator) }
  let!(:super_admin)        { create(:super_admin, accelerator_id: accelerator.id) }
  let!(:admin)              { create(:admin, accelerator_id: accelerator.id) }
    let!(:startup)          { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
      let!(:team_lead)      {create(:team_lead, accelerator_id: accelerator.id, startup_id: startup.id) }
      let!(:member)         {create(:member, startup_id: startup.id, accelerator_id: accelerator.id)}
  let!(:assessment)         { create(:assessment) }
    let!(:categories)       { create_list(:category, 3, assessment_id: assessment.id) }

  describe "not auth user" do
    let!(:user)  { nil }

    it "doesn't show all categories" do
      expect(policy_scope).to eq([])
    end
  end

  describe "user's type: SuperAdmin" do
    let!(:user)      { super_admin }

    it "shows all categories" do
      expect(policy_scope).to eq(categories)
    end
  end

  describe "user's type: Admin" do
    let!(:user)      { admin }

    it "shows all categories" do
      expect(policy_scope).to eq(categories)
    end

    it { is_expected.to forbid_actions(%i[show index]) }
  end

  describe "user's type: StartupAdmin" do
    let!(:user)      { team_lead }

    it "shows all categories" do
      expect(policy_scope).to eq(categories)
    end

    it { is_expected.to forbid_actions(%i[show index]) }
  end

  describe "user's type: Member" do
    let!(:user)      { member }

    it "shows all categories" do
      expect(policy_scope).to eq(categories)
    end

    it { is_expected.to forbid_actions(%i[show index]) }
  end
end
