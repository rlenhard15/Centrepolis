require 'rails_helper'

RSpec.describe NotificationPolicy, type: :policy do
  subject { described_class.new(user, notification) }

  let(:policy_scope) do
    described_class::Scope.new(user, Notification.all).resolve
  end

  let!(:admin)                 {create(:admin)}
    let!(:customer)            {create(:customer, created_by: admin.id)}
  let!(:assessment)            {create(:assessment)}
    let!(:category)            {create(:category, assessment_id: assessment.id)}
      let!(:sub_category)      {create(:sub_category, category_id: category.id)}
        let!(:stage)           {create(:stage, sub_category_id: sub_category.id)}
          let!(:task)          { create(:task, stage_id: stage.id, user_id: customer.id, created_by: admin.id)}
            let!(:notification){ create(:notification, task_id: task.id, customer_id: customer.id)}

  describe "not auth user" do
    let!(:user)  { nil }

    it "doesn't show all notifications" do
      expect(policy_scope).to eq([])
    end
  end

  describe "user's type: Admin" do
    let!(:user) { create(:admin) }

    it "dont show customers which admin created" do
      expect(policy_scope).to eq([])
    end

    it { is_expected.to forbid_actions(%i[index mark_as_readed mark_as_readed_all]) }
  end

  describe "user's type: Customer" do
    let!(:admin) {create(:admin)}
      let!(:user)  { create(:customer, created_by: admin.id) }

    it "show notifications for current customer" do
      expect(policy_scope).to eq(user.notifications)
    end
    it { is_expected.to permit_actions(%i[index mark_as_readed_all]) }
  end
end
