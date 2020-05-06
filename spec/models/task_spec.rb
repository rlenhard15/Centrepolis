require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "Associations" do
    it { should belong_to(:stage) }
    it { should belong_to(:admin).with_foreign_key('created_by') }
    it { should belong_to(:customer).with_foreign_key('user_id') }
    it { should have_one(:notification) }
  end

  describe "Method 'with_all_required_info_for_tasks'" do
    let!(:admin)            { create(:admin) }
      let!(:customer)       { create(:customer, created_by: admin.id) }
    let!(:assessment)       { create(:assessment) }
      let!(:category)       { create(:category, assessment_id: assessment.id) }
        let!(:sub_category) { create(:sub_category, category_id: category.id) }
          let!(:stage)      { create(:stage, sub_category_id: sub_category.id) }
            let!(:tasks)    { create_list(:task, 2, user_id: customer.id, created_by: admin.id, stage_id: stage.id) }

    it "return stages progress for sub_category" do
      tasks_info = Task.with_all_required_info_for_tasks.as_json

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
            "sub_category"=> sub_category.title,
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
            "sub_category"=> sub_category.title,
            "stage_title"=> stage.title
          }
        ]
      )
    end
  end
end
