module Admins
  class UsersController < ApplicationController

    api :POST, '/admins/create_customer', 'Admin create account for customer and invite his on email'
    param :user, Hash, required: true do
      param :email, String, desc: 'Unique email for customer', required: true
    end
    description <<-DESC
      === Success response body
      {
        "user": {
          "id": 49,
          "email": "customer_example@gmail.com",
          "created_at": "2020-03-02T12:43:28.691Z",
          "updated_at": "2020-03-02T12:43:28.691Z",
          "first_name": null,
          "last_name": null,
          "company_name": null,
          "created_by": 1
        }
      }
    DESC

    def create
      @customer = Customer.new( user_params.merge({
                                password: customer_random_password,
                                created_by: current_user.id
                                })
                              )
      authorize @customer, policy_class: UserPolicy

      if @customer.save
        UsersMailer.with(
          customer: @customer
        ).email_for_restore_password.deliver
        render json: @customer, status: :created
      else
        render json: @customer.errors, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:email)
    end

    def customer_random_password
      password_length = 8
      password = Devise.friendly_token.first(password_length)
    end
  end
end
