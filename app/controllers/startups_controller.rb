class StartupsController < ApplicationController

  api :POST, 'api/startups', "Create new startup and assign its to the specific admins"

  param :startup, Hash, required: true do
    param :name, String, desc: 'Name of startup', required: true
    param :admins_startups_attributes, Array, desc: 'required if current_user is SuperAdmin', required: true do
      param :admin_id, Integer, desc: 'Id of admin who have access to the startup', required: true
    end
  end

  description <<-DESC

  === Request headers
    Only SuperAdmin or Admin can perform this action
      Authentication - string - required
        Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
      Accelerator-Id - integer - required
        Example of Accelerator-Id header : 1

  === Success response body

  DESC


  def create
    authorize current_user, policy_class: StartupPolicy

    @startup = Startup.new(startup_admins_params.merge({accelerator_id: current_user.accelerator_id}))
    if @startup.save
      render json: @startup.as_json(methods: :admins_for_startup), status: :created
    else
      render json: @startup.errors, status: :unprocessable_entity
    end
  end

  private

  def startup_admins_params
    if startup_params[:admins_startups_attributes]
      admins_ids_for_startup = startup_params[:admins_startups_attributes].map { |admin| admin[:admin_id] }
    end

    @admins = current_user.super_admin? ? policy_scope(User).where({id: admins_ids_for_startup, type: "Admin"}) : [current_user]
    raise Pundit::NotAuthorizedError if @admins.empty? || @admins.nil?

    validated_admins_ids_hash = []

    @admins.each do |admin|
      validated_admins_ids_hash.push({admin_id: admin.id})
    end
    startup_params_hash = startup_params.to_h
    startup_params_hash[:admins_startups_attributes] = validated_admins_ids_hash
    return startup_params_hash
  end

  def startup_params
    params.require(:startup).permit(:name, admins_startups_attributes: [ :admin_id ])
  end
end
