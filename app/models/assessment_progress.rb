class AssessmentProgress < ApplicationRecord
  belongs_to :assessment
  belongs_to :member
end
