# frozen_string_literal: true

module Users
  class InvitesController < Devise::PasswordsController

    api :GET, '/users/resend_invite'
    param :user_id, Integer, required: true do
    end

    def show
      UsersMailer.with(
        user_id: params['user_id']
      ).email_for_restore_password.deliver_now
      render json: { success: true }
    end
  end
end