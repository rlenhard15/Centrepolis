require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "Associations" do
    it { should belong_to(:task) }
    it { should belong_to(:user) }
  end

  describe "Method 'with_task_info'" do
    let!(:accelerator)          { create(:accelerator) }
    let!(:super_admin)          { create(:super_admin) }
    let!(:admins)               { create_list(:admin, 2, accelerator_id: accelerator.id) }
    let!(:startups)             { create_list(:startup, 2, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.first.id}]) }
    let!(:startup_admin)        { create(:startup_admin, accelerator_id: accelerator.id, startup_id: startups.first.id) }
    let!(:member)               { create(:member, startup_id: startups.first.id, accelerator_id: accelerator.id) }
    let!(:assessment)           { create(:assessment) }
      let!(:category)           { create(:category, assessment_id: assessment.id) }
        let!(:sub_category)     { create(:sub_category, category_id: category.id) }
          let!(:stage)          { create(:stage, sub_category_id: sub_category.id) }
            let!(:task)         { create(:task, stage_id: stage.id, task_users_attributes: [{user_id: member.id}, {user_id: startup_admin.id}, {user_id: super_admin.id}, {user_id: admins.first.id}]) }


    it "return empty info if there arent notifications for the user" do
      notifications_list = Notification.where(user_id: admins.last.id).with_task_info.as_json

      expect(notifications_list).to eq([])
    end

    it "return all notifications" do
      notifications_list = Notification.with_task_info.as_json

      info_notifications = recursively_delete_timestamps(notifications_list)

      expect(info_notifications.count).to eq(16)
    end

    it "return all required info for notifications" do
      notifications_list = Notification.where(user_id: member.id).with_task_info.as_json


      info_notifications = recursively_delete_timestamps(notifications_list)

      expect(info_notifications).to eq(
        [
          {
            "id"=> task.notifications.where(user_id: member.id).first.id,
            "read"=> task.notifications.where(user_id: member.id).first.read,
            "task_title"=> task.title
          },
          {
            "id"=> task.notifications.where(user_id: member.id).first.id,
            "read"=> task.notifications.where(user_id: member.id).first.read,
            "task_title"=> task.title
          },
          {
            "id"=> task.notifications.where(user_id: member.id).first.id,
            "read"=> task.notifications.where(user_id: member.id).first.read,
            "task_title"=> task.title
          },
          {
            "id"=> task.notifications.where(user_id: member.id).first.id,
            "read"=> task.notifications.where(user_id: member.id).first.read,
            "task_title"=> task.title
          }
        ]
      )
    end
  end
end
