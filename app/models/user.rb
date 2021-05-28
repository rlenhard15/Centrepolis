class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :task_users, dependent: :destroy
  has_many :tasks, through: :task_users

  scope :members, -> { where(type: "Member") }
  scope :admins, -> { where(type: "Admin") }
  scope :startup_admins, -> { where(type: "StartupAdmin") }

  USER_TYPES = [
    SUPER_ADMIN = 'SuperAdmin',
    ADMIN = 'Admin',
    STARTUP_ADMIN = 'StartupAdmin',
    MEMBER = 'Member'
  ].freeze

  def full_name

    ("#{first_name} #{last_name}").gsub(/[A-Za-z']+/,&:capitalize)

  end

  def payload
    {
      auth_token: JwtWrapper.encode(user_id: id),
    }.merge(user_info)
  end

  def user_info
    {
      user_type: type,
      user: as_json
    }
  end

  def super_admin?
    type == SUPER_ADMIN
  end

  def admin?
    type == ADMIN
  end

  def startup_admin?
    type == STARTUP_ADMIN
  end

  def member?
    type == MEMBER
  end

  def frontend_hostname
    ENV[accelerator.hostname]
  end

  def self.set_user_by_password_token(attributes={})
    original_token       = attributes[:reset_password_token]
    reset_password_token = Devise.token_generator.digest(self, :reset_password_token, original_token)
    find_or_initialize_with_error_by(:reset_password_token, reset_password_token)
  end

  def reset_password_by_token(attributes={})
    if reset_password_period_valid?
      reset_password(attributes[:password], attributes[:password_confirmation])
    else
      errors.add(:reset_password_token, :expired)
    end
    reset_password_token = original_token if reset_password_token.present?
    self
  end

  private

    def send_email
      UsersMailer.with(
        user_id: self.id
      ).email_for_restore_password.deliver_later
    end
end
