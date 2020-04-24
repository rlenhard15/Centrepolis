class Notification < ApplicationRecord
  belongs_to :task
  belongs_to :customer
end
