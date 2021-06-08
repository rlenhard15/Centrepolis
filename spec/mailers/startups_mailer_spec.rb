require "rails_helper"

RSpec.describe StartupsMailer, type: :mailer do
  let!(:accelerator)   {create(:accelerator, hostname: 'FUZEHUB_HOST')}
  let!(:super_admin)   {create(:super_admin)}
  let!(:super_admin_2) {create(:super_admin, email_notification: false)}
  let!(:admin)         {create(:admin, accelerator_id: accelerator.id)}
  let!(:admin_2)       {create(:admin, accelerator_id: accelerator.id)}
  let!(:admin_3)       {create(:admin, accelerator_id: accelerator.id, email_notification: false)}
  let!(:startup)       {create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}, {admin_id: admin_3.id}]) }

  let!(:params)        {ActionController::Parameters.new({admin_ids: [admin.id, admin_2.id, admin_3.id], startup_id: startup.id})}
  let!(:params_2)      {ActionController::Parameters.new({admin_ids: [admin.id, admin_2.id, admin_3.id], startup_id: startup.id, super_admin_id: super_admin.id})}
  let!(:params_2_2)    {ActionController::Parameters.new({admin_ids: [admin.id, admin_2.id, admin_3.id], startup_id: startup.id, super_admin_id: super_admin_2.id})}
  let!(:params_3)      {ActionController::Parameters.new({current_user_id: admin.id, startup_id: startup.id, super_admin_ids: nil})}
  let!(:params_3_2)    {ActionController::Parameters.new({current_user_id: admin_3.id, startup_id: startup.id, super_admin_ids: nil})}
  let!(:params_4)      {ActionController::Parameters.new({current_user_id: admin.id, startup_id: startup.id, super_admin_ids: [super_admin.id, super_admin_2.id]})}

  let!(:mail)     {StartupsMailer.with(params).email_for_assigned_admins}
  let!(:mail_2)   {StartupsMailer.with(params_2).email_for_assigned_admins}
  let!(:mail_2_2) {StartupsMailer.with(params_2_2).email_for_assigned_admins}

  let!(:mail_3)   {StartupsMailer.with(params_3).email_startup_created}
  let!(:mail_3_2) {StartupsMailer.with(params_3_2).email_startup_created}
  let!(:mail_4)   {StartupsMailer.with(params_4).email_startup_created_to_super_admins}

  before do
    params.permit!
    params_2.permit!
    params_3.permit!
    params_4.permit!
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

  describe "Method email_for_assigned_admins to super_admin if super_admin is unsubscribed from email_notification" do
    it 'doest not send email' do
      expect(mail_2_2.message).to be_an_instance_of(ActionMailer::Base::NullMail)
    end
  end

  describe "Method email_startup_created" do
    it 'renders the subject' do
      expect(mail_3.subject).to eq("You created new startup on RAMP Client Business Planning Support")
    end

    it 'renders the receiver email if startup created by admin' do
      expect(mail_3.to).to eq([admin.email])
    end

    it 'renders the sender email' do
      expect(mail_3.from).to eq(['sender@mail.com'])
    end
  end

  describe "Method email_startup_created if admin who created startup is unsubscribedfrom email_notification" do
    it 'doest not send email' do
      expect(mail_3_2.message).to be_an_instance_of(ActionMailer::Base::NullMail)
    end
  end

  describe "Method email_startup_created_to_super_admins" do
    it 'renders the subject' do
      expect(mail_4.subject).to eq("New startup has been created on RAMP Client Business Planning Support")
    end

    it 'renders the receiver email' do
      expect(mail_4.to).to eq([super_admin.email])
    end

    it 'renders the sender email' do
      expect(mail_4.from).to eq(['sender@mail.com'])
    end
  end
end
