require 'rails_helper'

RSpec.describe AssessmentPolicy, type: :policy do
  subject { described_class.new(user, assessments) }

  let(:policy_scope) do
    described_class::Scope.new(user, Assessment.all).resolve
  end

  describe "not auth user" do
    let!(:assessments) {create_list(:assessment, 3)}
    let!(:user)  { nil }

    it "doesn't show all assessments" do
      expect(policy_scope).to eq([])
    end
  end

  describe "user's type: SuperAdmin" do
    let!(:assessments) {create_list(:assessment, 3)}
    let!(:accelerator) { create(:accelerator) }
    let!(:user)        { create(:super_admin) }

    it "shows all assessments" do
      expect(policy_scope).to eq(assessments)
    end

    it { is_expected.to permit_actions(%i[show index]) }
  end

  describe "user's type: Admin" do
    let!(:assessments) {create_list(:assessment, 3)}
    let!(:accelerator) { create(:accelerator) }
    let!(:user)        { create(:admin, accelerator_id: accelerator.id) }

    it "shows all assessments" do
      expect(policy_scope).to eq(assessments)
    end
  end

  describe "user's type: StartupAdmin" do
    let!(:assessments) {create_list(:assessment, 3)}
    let!(:accelerator) { create(:accelerator) }
    let!(:admin)       { create(:admin, accelerator_id: accelerator.id) }
      let!(:startup)   { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
        let!(:user)    { create(:startup_admin, startup_id: startup.id, accelerator_id: accelerator.id) }

    it "shows all assessments" do
      expect(policy_scope).to eq(assessments)
    end

    it { is_expected.to forbid_actions(%i[show index]) }
  end

  describe "user's type: Member" do
    let!(:assessments) {create_list(:assessment, 3)}
    let!(:accelerator) { create(:accelerator) }
    let!(:admin)       { create(:admin, accelerator_id: accelerator.id) }
      let!(:startup)   { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
        let!(:user)    { create(:member, startup_id: startup.id, accelerator_id: accelerator.id) }

    it "shows all assessments" do
      expect(policy_scope).to eq(assessments)
    end

    it { is_expected.to forbid_actions(%i[show index]) }
  end
end
