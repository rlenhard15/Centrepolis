require 'rails_helper'

RSpec.describe CustomerPolicy, type: :policy do
  subject { described_class.new(user, customers) }

  let(:policy_scope) do
    described_class::Scope.new(user, Customer.all).resolve
  end

  describe "not auth user" do
    let!(:accelerator) { create(:accelerator) }
    let!(:admin)       {create(:admin, accelerator_id: accelerator.id)}
      let!(:customers) {create_list(:customer, 3, created_by: admin.id, accelerator_id: accelerator.id)}
    let!(:user)  { nil }

    it "doesn't show all categories" do
      expect(policy_scope).to eq([])
    end
  end

  describe "user's type: Admin" do
    let!(:accelerator) { create(:accelerator) }
    let!(:user)        { create(:admin, accelerator_id: accelerator.id) }
      let!(:customers) {create_list(:customer, 3, created_by: user.id, accelerator_id: accelerator.id)}

    it "shows customers which admin created" do
      expect(policy_scope).to eq(user.customers)
    end

    it { is_expected.to permit_actions(%i[index create]) }
  end

  describe "user's type: Customer" do
    let!(:accelerator) { create(:accelerator) }
    let!(:admin)       {create(:admin, accelerator_id: accelerator.id)}
      let!(:customers) {create_list(:customer, 3, created_by: admin.id, accelerator_id: accelerator.id)}
    let!(:user)        { create(:customer, created_by: admin.id, accelerator_id: accelerator.id) }

    it "dont shows list of customers" do
      expect(policy_scope).to eq([])
    end

    it { is_expected.to forbid_actions(%i[index create]) }
  end
end
