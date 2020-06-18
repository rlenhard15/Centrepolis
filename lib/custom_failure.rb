class CustomFailure < Devise::FailureApp
  def redirect_url
    error_401_url
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
