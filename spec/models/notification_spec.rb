require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "Associations" do
    it { should belong_to(:task) }
    it { should belong_to(:customer) }
  end

  describe "Method 'with_task_and_admin_info'" do
    let!(:admin)              { create(:admin) }
      let!(:customer)         { create(:customer, created_by: admin.id) }
      let!(:customer_1)       { create(:customer, created_by: admin.id) }
      let!(:customer_2)       { create(:customer, created_by: admin.id) }
      let!(:customer_3)       { create(:customer, created_by: admin.id) }
    let!(:assessment)         { create(:assessment) }
    let!(:assessment_2)       { create(:assessment) }
      let!(:category)         { create(:category, assessment_id: assessment.id) }
      let!(:category_2)       { create(:category, assessment_id: assessment_2.id) }
        let!(:sub_category)   { create(:sub_category, category_id: category.id) }
        let!(:sub_category_2) { create(:sub_category, category_id: category_2.id) }
          let!(:stage)        { create(:stage, position: 1, sub_category_id: sub_category.id) }
          let!(:stage_2)      { create(:stage, position: 1, sub_category_id: sub_category_2.id) }
    let!(:task_1)             { create(:task, user_id: customer.id, created_by: admin.id, stage_id: stage.id) }
      let!(:notification_1)   { create(:notification, customer_id: customer.id, task_id: task_1.id) }
    let!(:task_2)             { create(:task, user_id: customer.id, created_by: admin.id, stage_id: stage.id) }
      let!(:notification_2)   { create(:notification, customer_id: customer.id, task_id: task_2.id) }
      let!(:task_3)           { create(:task, user_id: customer_2.id, created_by: admin.id, stage_id: stage.id) }
        let!(:notification_3) { create(:notification, customer_id: customer_2.id, task_id: task_3.id) }
      let!(:task_4)           { create(:task, user_id: customer_3.id, created_by: admin.id, stage_id: stage_2.id) }
        let!(:notification_4) { create(:notification, customer_id: customer_3.id, task_id: task_4.id) }

    it "return empty info if there arent notifications for customer" do
      notifications_list = Notification.where(customer_id: customer_1.id).with_task_and_admin_info.as_json

      expect(notifications_list).to eq([])
    end

    it "return all notifications" do
      notifications_list = Notification.with_task_and_admin_info.as_json

      info_notifications = recursively_delete_timestamps(notifications_list)

      expect(info_notifications).to eq(
        [
          {
            "id"=> notification_1.id,
            "read"=> notification_1.read,
            "task_title"=> task_1.title,
            "admin_name"=> (admin.first_name + " " + admin.last_name)
          },
          {
            "id"=> notification_2.id,
           "read"=> notification_2.read,
           "task_title"=> task_2.title,
           "admin_name"=> (admin.first_name + " " + admin.last_name)
          },
          {
           "id"=> notification_3.id,
           "read"=> notification_3.read,
           "task_title"=> task_3.title,
           "admin_name"=> (admin.first_name + " " + admin.last_name)
          },
          {
           "id"=> notification_4.id,
           "read"=> notification_4.read,
           "task_title"=> task_4.title,
           "admin_name"=> (admin.first_name + " " + admin.last_name)
          }
        ]
      )
    end

    it "return all required info for notifications" do
      notifications_list = Notification.where(customer_id: customer.id).with_task_and_admin_info.as_json

      info_notifications = recursively_delete_timestamps(notifications_list)

      expect(info_notifications).to eq(
        [
          {
            "id"=> notification_1.id,
            "read"=> notification_1.read,
            "task_title"=> task_1.title,
            "admin_name"=> (admin.first_name + " " + admin.last_name)
          },
          {
            "id"=> notification_2.id,
            "read"=> notification_2.read,
            "task_title"=> task_2.title,
            "admin_name"=> (admin.first_name + " " + admin.last_name)
          }
        ]
      )
    end
  end
end
