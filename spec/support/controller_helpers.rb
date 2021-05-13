module ControllerHelpers
  def sign_in(user)
    if !user.super_admin?
      if user && request.headers['Accelerator-Id'].to_i == user.accelerator_id
        allow(request.env['warden']).to receive(:authenticate!).and_return(user)
        allow(controller).to receive(:current_user).and_return(user)
      else
        allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
        allow(controller).to receive(:current_user).and_return(nil)
      end
    else
      if user && Accelerator.ids.include?(request.headers['Accelerator-Id'].to_i)
        allow(request.env['warden']).to receive(:authenticate!).and_return(user)
        allow(controller).to receive(:current_user).and_return(user)
      else
        allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
        allow(controller).to receive(:current_user).and_return(nil)
      end
    end
  end
end
