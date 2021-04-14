require 'rails_helper'

RSpec.describe StartupAdmin, type: :model do
  describe "Associations" do
    it { should belong_to(:startup).with_foreign_key('startup_id') }
  end
end
