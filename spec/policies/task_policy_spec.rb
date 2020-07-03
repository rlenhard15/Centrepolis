require 'rails_helper'

RSpec.describe TaskPolicy, type: :policy do
  subject { described_class.new(user, task) }

  let(:policy_scope) do
    described_class::Scope.new(user, Task.all).resolve
  end

  let!(:accelerator)      { create(:accelerator) }
  let!(:admin)            {create(:admin, accelerator_id: accelerator.id)}
    let!(:customer)       {create(:customer, created_by: admin.id, accelerator_id: accelerator.id)}
  let!(:assessment)       {create(:assessment)}
    let!(:category)       {create(:category, assessment_id: assessment.id)}
      let!(:sub_category) {create(:sub_category, category_id: category.id)}
        let!(:stage)      {create(:stage, sub_category_id: sub_category.id)}
          let!(:task)     { create(:task, stage_id: stage.id, user_id: customer.id, created_by: admin.id)}

  describe "user's type: Admin" do
    let!(:accelerator) { create(:accelerator) }
    let!(:user)        { create(:admin, accelerator_id: accelerator.id) }

    it "show tasks for current admin" do
      expect(policy_scope).to eq(user.tasks)
    end

    it { is_expected.to permit_actions(%i[create]) }
  end

  describe "user's type: Customer" do
    let!(:accelerator) { create(:accelerator) }
    let!(:user)        { create(:customer, created_by: admin.id, accelerator_id: accelerator.id) }

    it "show tasks for current customer" do
      expect(policy_scope).to eq(user.tasks)
    end

    it { is_expected.to forbid_actions(%i[index show mark_task_as_completed]) }
  end
end
