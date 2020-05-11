require "rails_helper"

RSpec.describe UsersMailer, type: :mailer do
  let!(:admin)    {create(:admin)}
  let!(:customer) {create(:customer, created_by: admin.id)}
  let!(:params)   {ActionController::Parameters.new({customer: customer})}
  before {params.permit!}

  let!(:mail) {UsersMailer.with(params).email_for_restore_password}

  it 'renders the subject' do
    expect(mail.subject).to eq("You have been invited to Trello forms")
  end

  it 'renders the receiver email' do
    expect(mail.to).to eq([customer.email])
  end

  it 'renders the sender email' do
    expect(mail.from).to eq([ENV['SENDER_EMAIL']])
  end
end
