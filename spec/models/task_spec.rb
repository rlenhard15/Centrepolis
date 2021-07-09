require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "Associations" do
    it { should belong_to(:stage) }
    it { should have_many(:task_users).dependent(:destroy) }
    it { should have_many(:users).through(:task_users) }
    it { should have_many(:notifications).dependent(:destroy) }
  end

  describe "callbacks" do
    let!(:accelerator)           { create(:accelerator) }
    let!(:admin)                 { create(:admin, accelerator_id: accelerator.id) }
      let!(:startup)             { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
        let!(:member)            { create(:member, accelerator_id: accelerator.id, startup_id: startup.id) }
    let!(:assessment)            { create(:assessment) }
      let!(:category)            { create(:category, assessment_id: assessment.id) }
        let!(:sub_category)      { create(:sub_category, category_id: category.id) }
          let!(:stage)           { create(:stage, sub_category_id: sub_category.id) }
            let!(:task)          { create(:task, stage_id: stage.id, task_users_attributes: [{user_id: member.id}]) }

    it { expect(task).to callback(:create_notifications).after(:create) }
  end

  let!(:accelerator)       { create(:accelerator) }
    let!(:super_admin)     { create(:super_admin) }
    let!(:admin)           { create(:admin, accelerator_id: accelerator.id) }
      let!(:startup)       { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
    let!(:team_lead)       { create(:team_lead, accelerator_id: accelerator.id, startup_id: startup.id) }
    let!(:member)          { create(:member, accelerator_id: accelerator.id, startup_id: startup.id) }
    let!(:member_2)        { create(:member, accelerator_id: accelerator.id, startup_id: startup.id) }
  let!(:assessment)        { create(:assessment) }
  let!(:assessment_2)      { create(:assessment) }
    let!(:category)        { create(:category, assessment_id: assessment.id) }
    let!(:category_2)      { create(:category, assessment_id: assessment_2.id) }
      let!(:sub_categories){ create_list(:sub_category, 2, category_id: category.id) }
      let!(:sub_category)  { create(:sub_category, category_id: category_2.id) }
        let!(:stage)       { create(:stage, sub_category_id: sub_categories.first.id) }
        let!(:stage_2)     { create(:stage, sub_category_id: sub_category.id) }
          let!(:tasks)     { create_list(:task, 2, stage_id: stage.id, task_users_attributes: [{user_id: member.id}, {user_id: team_lead.id}]) }
          let!(:tasks_2)   { create_list(:task, 2, stage_id: stage_2.id, task_users_attributes: [{user_id: member_2.id}, {user_id: team_lead.id}]) }

  describe "Method 'with_all_required_info_for_tasks'" do
    it "return tasks for current user" do
      tasks_info = Task.joins(:users).where("users.id = ?", member.id).with_all_required_info_for_tasks.order(created_at: :asc).as_json

      recursively_delete_timestamps(tasks_info)

      expect(tasks_info).to eq(
        [
          {
            "id"=> tasks.first.id,
            "title"=> tasks.first.title,
            "priority"=> tasks.first.priority,
            "due_date"=> tasks.first.due_date,
            "status"=> tasks.first.status,
            "master_assessment"=> assessment.name,
            "category"=> category.title,
            "sub_category"=> sub_categories.first.title,
            "stage_title"=> stage.title
          },
          {
            "id"=> tasks.last.id,
            "title"=> tasks.last.title,
            "priority"=> tasks.last.priority,
            "due_date"=> tasks.last.due_date,
            "status"=> tasks.last.status,
            "master_assessment"=> assessment.name,
            "category"=> category.title,
            "sub_category"=> sub_categories.last.title,
            "stage_title"=> stage.title
          }
        ]
      )
    end
  end

  describe "Method 'tasks_for_startup'" do
    it "return tasks for the startup" do
      tasks_info = Task.joins(:users).tasks_for_startup(startup.id).as_json

      recursively_delete_timestamps(tasks_info)

      expect(tasks_info.count).to eq(8)
    end
  end

  describe "Method 'members_for_task'" do
    it "return members assigned to the task" do
      users_info = tasks.first.members_for_task.as_json

      recursively_delete_timestamps(users_info)

      expect(users_info).to eq(
        [
          {
            "id"=> member.id,
            "email"=> member.email,
            "first_name"=> member.first_name,
            "last_name"=> member.last_name,
            "accelerator_id"=> member.accelerator_id,
            "startup_id"=> member.startup_id,
            "phone_number"=> member.phone_number,
            "email_notification"=> member.email_notification
          }
        ]
      )
    end
  end
end
