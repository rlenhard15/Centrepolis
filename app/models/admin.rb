class Admin < User
  has_many :startups, foreign_key: "created_by"
end
