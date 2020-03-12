require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "Associations" do
    it { should belong_to(:stage) }
    it { should belong_to(:user) }
  end
end
