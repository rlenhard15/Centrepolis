require 'rails_helper'

RSpec.describe Startup, type: :model do
  describe "Associations" do
    it { should have_many(:startup_admins).with_foreign_key('startup_id') }
    it { should have_many(:members).with_foreign_key('startup_id') }
    it { should have_many(:admins_startups).dependent(:destroy) }
    it { should have_many(:admins).through(:admins_startups) }
    it { should have_many(:sub_category_progresses).dependent(:destroy) }
    it { should have_many(:assessment_progresses).dependent(:destroy) }
  end

  let!(:accelerator)          { create(:accelerator) }
  let!(:super_admin)          { create(:super_admin) }
  let!(:admins)               { create_list(:admin, 2, accelerator_id: accelerator.id) }
    let!(:startup)            { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.first.id}, {admin_id: admins.last.id}]) }

  describe "Method 'admins_for_startup'" do
    it "return admins assigned to the startup" do
      admins_info = startup.admins_for_startup.as_json

      recursively_delete_timestamps(admins_info)

      expect(admins_info).to eq(
        [
          {
            "id"=> admins.first.id,
            "email"=> admins.first.email,
            "first_name"=> admins.first.first_name,
            "last_name"=> admins.first.last_name,
            "accelerator_id"=> admins.first.accelerator_id,
            "startup_id"=> admins.first.startup_id
          },
          {
            "id"=> admins.last.id,
            "email"=> admins.last.email,
            "first_name"=> admins.last.first_name,
            "last_name"=> admins.last.last_name,
            "accelerator_id"=> admins.last.accelerator_id,
            "startup_id"=> admins.last.startup_id
          },
        ]
      )
    end
  end
end
