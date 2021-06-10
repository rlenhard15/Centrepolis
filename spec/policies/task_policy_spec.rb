require 'rails_helper'

RSpec.describe TaskPolicy, type: :policy do
  subject { described_class.new(user, task) }

  let(:policy_scope) do
    described_class::Scope.new(user, Task.all).resolve
  end

  let!(:accelerator)      { create(:accelerator) }
  let!(:super_admin)      { create(:super_admin) }
  let!(:admin)            {create(:admin, accelerator_id: accelerator.id)}
    let!(:member)         { create(:member, accelerator_id: accelerator.id, startup_id: startup.id) }
  let!(:startup)          { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
    let!(:startup_admin)  { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup.id) }
  let!(:assessment)       {create(:assessment)}
    let!(:category)       {create(:category, assessment_id: assessment.id)}
      let!(:sub_category) {create(:sub_category, category_id: category.id)}
        let!(:stage)      {create(:stage, sub_category_id: sub_category.id)}
          let!(:task)     { create(:task, stage_id: stage.id, task_users_attributes: [{user_id: member.id}, {user_id: startup_admin.id}]) }

  describe "user's type: SuperAdmin" do
    let!(:accelerator) { create(:accelerator) }
    let!(:user)        { create(:super_admin) }

    it "show tasks for current super_admin" do
      expect(policy_scope).to eq(Task.joins(:users))
    end

    it { is_expected.to permit_actions(%i[create destroy update index show mark_task_as_completed]) }
  end

  describe "user's type: Admin" do
    let!(:accelerator) { create(:accelerator) }
    let!(:user)        { create(:admin, accelerator_id: accelerator.id) }

    it "show tasks for current admin" do
      expect(policy_scope).to eq(Task.joins(:users).where("users.startup_id IN (?) ", user.startup_ids))
    end

    it { is_expected.to permit_actions(%i[create]) }
    it { is_expected.to forbid_actions(%i[destroy update]) }
  end

  describe "user's type: StartupAdmin" do
    let!(:accelerator) { create(:accelerator) }
    let!(:user)        { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startup.id) }

    it "show tasks for current startup_admin" do
      expect(policy_scope).to eq(user.tasks)
    end
  end

  describe "user's type: Member" do
    let!(:accelerator) { create(:accelerator) }
    let!(:user)        { create(:member, accelerator_id: accelerator.id, startup_id: startup.id) }

    it "show tasks for current member" do
      expect(policy_scope).to eq(user.tasks)
    end
  end
end
