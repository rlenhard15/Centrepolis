# frozen_string_literal: true

module JWTWrapper
  module_function

  def encode(payload, expiration = nil)
    expiration ||= ENV['JWT_EXPIRATION_HOURS']
    payload = payload.dup
    # payload['exp'] = expiration.to_i.hours.from_now.to_i
    JWT.encode payload, ENV['JWT_SECRET']
  end

  def decode(token)
    decoded_token = JWT.decode token, ENV['JWT_SECRET']
    decoded_token.first
  rescue StandardError
    nil
  end
end
