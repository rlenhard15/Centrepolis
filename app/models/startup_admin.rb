class StartupAdmin < User
  belongs_to :startup, foreign_key: "startup_id"
  belongs_to :accelerator, foreign_key: "accelerator_id"

  after_create :send_email
end
