require 'rails_helper'

RSpec.describe NotificationPolicy, type: :policy do
  subject { described_class.new(user, notification) }

  let(:policy_scope) do
    described_class::Scope.new(user, Notification.all).resolve
  end

  let!(:accelerator)                { create(:accelerator) }
  let!(:super_admin)                { create(:super_admin) }
  let!(:admins)                     { create_list(:admin, 2, accelerator_id: accelerator.id) }
  let!(:startups)                   { create_list(:startup, 2, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.first.id}]) }
  let!(:team_lead)                  { create(:team_lead, accelerator_id: accelerator.id, startup_id: startups.first.id) }
  let!(:member)                     { create(:member, startup_id: startups.first.id, accelerator_id: accelerator.id) }
  let!(:assessment)                 { create(:assessment) }
    let!(:category)                 { create(:category, assessment_id: assessment.id) }
      let!(:sub_category)           { create(:sub_category, category_id: category.id) }
        let!(:stage)                { create(:stage, sub_category_id: sub_category.id) }
          let!(:tasks)              { create_list(:task, 2, stage_id: stage.id, task_users_attributes: [{user_id: member.id}, {user_id: team_lead.id}, {user_id: super_admin.id}, {user_id: admins.first.id}]) }
            let!(:notification)     { create(:notification, user_id: super_admin.id, task_id: tasks.first.id)}
            let!(:notification_1)   { create(:notification, user_id: admins.first.id, task_id: tasks.first.id)}
            let!(:notification_2)   { create(:notification, user_id: team_lead.id, task_id: tasks.first.id)}
            let!(:notification_3)   { create(:notification, user_id: member.id, task_id: tasks.first.id)}

  describe "not auth user" do
    let!(:user)  { nil }

    it "doesn't show all notifications" do
      expect(policy_scope).to eq([])
    end
  end

  describe "user's type: SuperAdmin" do
    let!(:user)        { super_admin }

    it "show notifications for current customer" do
      expect(policy_scope).to eq(Notification.where(user_id: user.id))
    end

    it { is_expected.to permit_actions(%i[index mark_as_readed mark_as_readed_all]) }
  end

  describe "user's type: Admin" do
    let!(:user)        { admins.first }

    it "show notifications for current customer" do
      expect(policy_scope).to eq(Notification.where(user_id: user.id))
    end

    it { is_expected.to permit_actions(%i[index mark_as_readed_all]) }
  end

  describe "user's type: StartupAdmin" do
    let!(:user)        { team_lead }

    it "show notifications for current customer" do
      expect(policy_scope).to eq(Notification.where(user_id: user.id))
    end

    it { is_expected.to permit_actions(%i[index mark_as_readed_all]) }
  end

  describe "user's type: Member" do
    let!(:user)      { member }

    it "show notifications for current customer" do
      expect(policy_scope).to eq(Notification.where(user_id: user.id))
    end

    it { is_expected.to permit_actions(%i[index mark_as_readed_all]) }
  end
end
