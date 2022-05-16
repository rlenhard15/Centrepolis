require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe "Associations" do
    it { should have_many(:admins_startups).with_foreign_key('admin_id').dependent(:destroy) }
    it { should have_many(:startups).through(:admins_startups) }
    it { should belong_to(:accelerator).with_foreign_key('accelerator_id') }
  end

  describe "callbacks" do
    let!(:accelerator)       { create(:accelerator) }
    let!(:admin)             { create(:admin, accelerator_id: accelerator.id) }

    it { expect(admin).to callback(:send_email).after(:create) }
    it { expect(admin).to callback(:send_email_about_delete_account).after(:destroy) }
  end
end
