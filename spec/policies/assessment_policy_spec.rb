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

  describe "user's type: Admin" do
    let!(:assessments) {create_list(:assessment, 3)}
    let!(:user)  { create(:admin) }

    it "shows all assessments" do
      expect(policy_scope).to eq(assessments)
    end

    it { is_expected.to permit_actions(%i[show index]) }
  end

  describe "user's type: Customer" do
    let!(:assessments) {create_list(:assessment, 3)}
    let!(:admin)  { create(:admin) }
      let!(:user)  { create(:customer, created_by: admin.id) }

    it "shows all assessments" do
      expect(policy_scope).to eq(assessments)
    end

    it { is_expected.to forbid_actions(%i[show index]) }
  end
end
