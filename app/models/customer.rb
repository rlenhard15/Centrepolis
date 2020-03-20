class Customer < User
  belongs_to :admin, foreign_key: "created_by"
end
