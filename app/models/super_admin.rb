class SuperAdmin < User
  after_create :send_email
end
