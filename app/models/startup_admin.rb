class StartupAdmin < User
  belongs_to :startup

  after_create :send_email
end
