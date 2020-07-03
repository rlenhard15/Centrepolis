require "rails_helper"

RSpec.describe UsersMailer, type: :mailer do
  let!(:accelerator) {create(:accelerator, hostname: 'FUZEHUB_HOST')}
  let!(:admin)       {create(:admin, accelerator_id: accelerator.id)}
  let!(:customer)    {create(:customer, created_by: admin.id, accelerator_id: accelerator.id)}
  let!(:params)      {ActionController::Parameters.new({customer: customer})}

  let!(:mail) {UsersMailer.with(params).email_for_restore_password}

  before do
    params.permit!
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('SENDER_EMAIL').and_return('sender@mail.com')
    allow(ENV).to receive(:[]).with('ADMIN_PANEL_HOST').and_return('http://localhost:3000')
    allow(ENV).to receive(:[]).with('FUZEHUB_HOST').and_return('fuzehub_host')
  end

  it 'renders the subject' do
    expect(mail.subject).to eq("You have been invited to RAMP Client Business Planning Support")
  end

  it 'renders the receiver email' do
    expect(mail.to).to eq([customer.email])
  end

  it 'renders the sender email' do
    expect(mail.from).to eq(['sender@mail.com'])
  end
end
