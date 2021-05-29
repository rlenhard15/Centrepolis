require "rails_helper"

RSpec.describe StartupsMailer, type: :mailer do
  let!(:accelerator)   {create(:accelerator, hostname: 'FUZEHUB_HOST')}
  let!(:super_admin)   {create(:super_admin)}
  let!(:admin)         {create(:admin, accelerator_id: accelerator.id)}
  let!(:admin_2)       {create(:admin, accelerator_id: accelerator.id)}
  let!(:startup)       {create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }

  let!(:params)        {ActionController::Parameters.new({admin_ids: [admin.id, admin_2.id], startup_id: startup.id})}
  let!(:params_2)      {ActionController::Parameters.new({admin_ids: [admin.id, admin_2.id], startup_id: startup.id, super_admin_id: super_admin.id})}

  let!(:mail)   {StartupsMailer.with(params).email_for_assigned_admins}
  let!(:mail_2) {StartupsMailer.with(params_2).email_for_assigned_admins}

  before do
    params.permit!
    params_2.permit!
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('SENDER_EMAIL').and_return('sender@mail.com')
    allow(ENV).to receive(:[]).with('FUZEHUB_HOST').and_return('fuzehub_host')
  end

  describe "Method email_for_assigned_admins to assigned admins" do
    it 'renders the subject' do
      expect(mail.subject).to eq("You have been assigned to startup on RAMP Client Business Planning Support")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([admin.email, admin_2.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['sender@mail.com'])
    end
  end

  describe "Method email_for_assigned_admins to super_admin" do
    it 'renders the subject' do
      expect(mail_2.subject).to eq("You assigned admin(s) to a startup on RAMP Client Business Planning Support")
    end

    it 'renders the receiver email' do
      expect(mail_2.to).to eq([super_admin.email])
    end

    it 'renders the sender email' do
      expect(mail_2.from).to eq(['sender@mail.com'])
    end
  end
end
