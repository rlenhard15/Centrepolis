require "rails_helper"

RSpec.describe UsersMailer, type: :mailer do
  let!(:accelerator) {create(:accelerator, hostname: 'FUZEHUB_HOST')}
  let!(:super_admin) {create(:super_admin)}
  let!(:admin)       {create(:admin, accelerator_id: accelerator.id)}
  let!(:startup)     {create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
  let!(:member)      {create(:member, startup_id: startup.id, accelerator_id: accelerator.id)}
  let!(:params)      {ActionController::Parameters.new({user_id: member.id})}
  let!(:params_2)    {ActionController::Parameters.new({deleted_admin: admin})}
  let!(:params_3)    {ActionController::Parameters.new({deleted_admin: admin, super_admin_id: super_admin.id})}

  let!(:mail)   {UsersMailer.with(params).email_for_restore_password}
  let!(:mail_2) {UsersMailer.with(params_2).email_after_delete_admin}
  let!(:mail_3) {UsersMailer.with(params_3).email_after_delete_admin}


  before do
    params.permit!
    params_2.permit!
    params_3.permit!
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('SENDER_EMAIL').and_return('sender@mail.com')
    allow(ENV).to receive(:[]).with('ADMIN_PANEL_HOST').and_return('http://localhost:3000')
    allow(ENV).to receive(:[]).with('FUZEHUB_HOST').and_return('fuzehub_host')
  end

  describe "METHOD email_for_restore_password" do
    it 'renders the subject' do
      expect(mail.subject).to eq("You have been invited to RAMP Client Business Planning Support")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([member.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['sender@mail.com'])
    end
  end

  describe "METHOD email_after_delete_admin" do
    it 'renders the subject to admin' do
      expect(mail_2.subject).to eq("Your account has been deleted on RAMP Client Business Planning Support")
    end

    it 'renders the receiver email to admin' do
      expect(mail_2.to).to eq([admin.email])
    end

    it 'renders the sender email to admin' do
      expect(mail_2.from).to eq(['sender@mail.com'])
    end

    it 'renders the subject to super_admin' do
      expect(mail_3.subject).to eq("You deleted admin account on RAMP Client Business Planning Support")
    end

    it 'renders the receiver email to super_admin' do
      expect(mail_3.to).to eq([super_admin.email])
    end

    it 'renders the sender email to super_admin' do
      expect(mail_3.from).to eq(['sender@mail.com'])
    end
  end
end
