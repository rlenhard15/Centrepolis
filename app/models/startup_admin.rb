class StartupAdmin < User
  belongs_to :startup, foreign_key: "startup_id"
end
