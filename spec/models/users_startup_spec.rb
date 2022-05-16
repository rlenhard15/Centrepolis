require 'rails_helper'

RSpec.describe UsersStartup, type: :model do
  describe "Associations" do
    it { should belong_to(:startup).with_foreign_key('startup_id') }
    it { should belong_to(:user).with_foreign_key('user_id') }
  end
end
