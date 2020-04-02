class AssessmentProgress < ApplicationRecord
  belongs_to :assessment
  belongs_to :customer
end
