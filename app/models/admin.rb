class Admin < User
  has_many :customers, foreign_key: "created_by"
  has_many :tasks, foreign_key: "created_by"
end
