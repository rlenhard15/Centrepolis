require 'rails_helper'

RSpec.describe CustomerPolicy, type: :policy do
  subject { described_class.new(user, customers) }

  let(:policy_scope) do
    described_class::Scope.new(user, Customer.all).resolve
  end

  describe "not auth user" do
    let!(:admin) {create(:admin)}
      let!(:customers) {create_list(:customer, 3, created_by: admin.id)}
    let!(:user)  { nil }

    it "doesn't show all categories" do
      expect(policy_scope).to eq([])
    end
  end

  describe "user's type: Admin" do
    let!(:user)        { create(:admin) }
      let!(:customers) {create_list(:customer, 3, created_by: user.id)}

    it "shows customers which admin created" do
      expect(policy_scope).to eq(user.customers)
    end

    it { is_expected.to permit_actions(%i[index create]) }
  end

  describe "user's type: Customer" do
    let!(:admin) {create(:admin)}
      let!(:customers) {create_list(:customer, 3, created_by: admin.id)}
    let!(:user)  { create(:customer, created_by: admin.id) }

    it "dont shows list of customers" do
      expect(policy_scope).to eq([])
    end

    it { is_expected.to forbid_actions(%i[index create]) }
  end
end
