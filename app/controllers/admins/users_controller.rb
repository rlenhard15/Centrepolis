module Admins
  class UsersController < ApplicationController

    def create
      @customer = Customer.new(
                                user_params.merge({
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
