require 'rails_helper'

RSpec.describe AdminsStartup, type: :model do
  describe "Associations" do
    it { should belong_to(:startup) }
    it { should belong_to(:admin).with_foreign_key('admin_id') }
  end
end
