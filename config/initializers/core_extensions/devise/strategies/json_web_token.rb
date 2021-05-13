module Devise
  module Strategies
    class JsonWebToken < Base
      def valid?
        request.headers['Authorization'].present?
      end

      def authenticate!
        failed = check_fail
        failed ? failed : (success! user_from_db)
      end

      protected

      def user_from_db
        @user_from_db ||= User.find_by_id(claims['user_id'])
      end

      def token_from_header
        strategy, token = request.headers['Authorization'].split(' ')
        return nil if (strategy || '').capitalize != 'Bearer'
        token
      end

      def decoded_token
        JwtWrapper.decode(token_from_header) rescue nil
      end

      def claims
        @claims ||= decoded_token
      end

      def check_fail
        return fail! unless claims
        return fail! unless claims.has_key?('user_id')
        return fail! unless user_from_db
        return fail! unless accelerator_id_for_user_type
        false
      end

      def accelerator_id_for_user_type
        if !user_from_db.super_admin?
          user_from_db.accelerator_id == request.headers['Accelerator-Id'].to_i
        else
          Accelerator.ids.include?(request.headers['Accelerator-Id'].to_i)
        end
      end
    end
  end
end
