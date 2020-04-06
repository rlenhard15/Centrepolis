module Admins
  class CustomersController < ApplicationController

    api :GET, 'api/customers', "Only admin can see list of customers"
    description <<-DESC

    === Request headers
      Only admin can perform this action
        Authentication - string - required
          Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

    === Params
      Params are absent

    === Success response body
    [
      {
        "id": 290,
        "email": "customer_example@gmail.com",
        "created_at": "2020-03-23T11:51:56.801Z",
        "updated_at": "2020-03-23T11:52:32.725Z",
        "first_name": "Xu",
        "last_name": "Xian",
        "company_name": "Company name",
        "created_by": 101,
        "assessment_risk_list": [
          {
            "assessment": "First assessment",
            "risk_value": "3.92156862745098"
          },
          ...
        ]
      },
      ...
    ]

    DESC
    def index
      authorize current_user, policy_class: CustomerPolicy

      @customers = policy_scope(Customer)
      render json: @customers.as_json(methods: :assessments_risk_list)
    end

    api :POST, 'api/customers', 'Only admin can create account for customer and invite his on email'
    param :user, Hash, required: true do
      param :email, String, desc: 'Unique email for customer', required: true
      param :company_name, String, desc: 'Unique company name for customer', required: true
    end

    description <<-DESC

      === Request headers
        Only admin can perform this action
          Authentication - string - required
            Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

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
