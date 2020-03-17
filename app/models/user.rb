class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tasks, dependent: :destroy

  USER_TYPES = [
    ADMIN = 'Admin',
    CUSTOMER = 'Customer'
  ].freeze

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
end
