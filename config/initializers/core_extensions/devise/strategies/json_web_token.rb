module Devise
  module Strategies
    class JsonWebToken < Base
      def valid?
        request.headers['Authorization'].present?
      end

      def authenticate!
        failed = check_fail
        failed ? failed : (success! User.find_by_id(claims['user_id']))
      end

      protected

      def token_from_header
        strategy, token = request.headers['Authorization'].split(' ')
        return nil if (strategy || '').downcase != 'bearer'
        token
      end

      def decoded_token
        JWTWrapper.decode(token_from_header) rescue nil
      end

      def claims
        @claims ||= decoded_token
      end

      def check_fail
        return fail! unless claims
        return fail! unless claims.has_key?('user_id')
        false
      end
    end
  end
end
