module Admins
  class CustomersController < ApplicationController

    api :POST, 'api/customers', 'Admin create account for customer and invite his on email'
    param :user, Hash, required: true do
      param :email, String, desc: 'Unique email for customer', required: true
      param :company_name, String, desc: 'Unique company name for customer', required: true
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
          "company_name": "MSI",
          "created_by": 1
        }
      }
    DESC

    def create
      @customer = Customer.new(
        user_params.merge({
          password: customer_random_password,
          created_by: current_user.id
        })
      )
      authorize @customer

      if @customer.save
        render json: @customer, status: :created
      else
        render json: @customer.errors, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:customer).permit(:email, :company_name)
    end

    def customer_random_password
      Devise.friendly_token.first(8)
    end
  end
end
