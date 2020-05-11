require 'rails_helper'

RSpec.describe CategoryPolicy, type: :policy do
  subject { described_class.new(user, categories) }

  let(:policy_scope) do
    described_class::Scope.new(user, Category.all).resolve
  end

  describe "not auth user" do
    let!(:assessment) {create(:assessment)}
      let!(:categories) {create_list(:category, 3, assessment_id: assessment.id)}
    let!(:user)  { nil }

    it "doesn't show all categories" do
      expect(policy_scope).to eq([])
    end
  end

  describe "user's type: Admin" do
    let!(:assessment) {create(:assessment)}
      let!(:categories) {create_list(:category, 3, assessment_id: assessment.id)}
    let!(:user)  { create(:admin) }

    it "shows all categories" do
      expect(policy_scope).to eq(categories)
    end

    it { is_expected.to permit_actions(%i[show index]) }
  end

  describe "user's type: Customer" do
    let!(:assessment) {create(:assessment)}
      let!(:categories) {create_list(:category, 3, assessment_id: assessment.id)}
    let!(:admin)  { create(:admin) }
      let!(:user)  { create(:customer, created_by: admin.id) }

    it "shows all categories" do
      expect(policy_scope).to eq(categories)
    end

    it { is_expected.to forbid_actions(%i[show index]) }
  end
end
