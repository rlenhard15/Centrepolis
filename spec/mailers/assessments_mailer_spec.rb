require "rails_helper"

RSpec.describe AssessmentsMailer, type: :mailer do
  let!(:accelerator)                   {create(:accelerator, hostname: 'FUZEHUB_HOST')}
  let!(:super_admin)                   {create(:super_admin)}
  let!(:admins)                        {create_list(:admin, 3, accelerator_id: accelerator.id)}
  let!(:startup)                       {create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admins.first.id}, {admin_id: admins.second.id}, {admin_id: admins.last.id}]) }
  let!(:member)                        {create(:member, startup_id: startup.id, accelerator_id: accelerator.id)}
  let!(:startup_admin)                 {create(:startup_admin, startup_id: startup.id, accelerator_id: accelerator.id)}
  let!(:startup_admin_2)               {create(:startup_admin, startup_id: startup.id, accelerator_id: accelerator.id)}
  let!(:assessment)                    {create(:assessment)}
    let!(:category)                    {create(:category, assessment_id: assessment.id)}
      let!(:sub_category)              {create(:sub_category, category_id: category.id)}
        let!(:stage)                   {create(:stage, sub_category_id: sub_category.id)}
          let!(:sub_category_progress) { create(:sub_category_progress, startup_id: startup.id, sub_category_id: sub_category.id, current_stage_id: stage.id) }
          let!(:assessment_progress)   { create(:assessment_progress, startup_id: startup.id, assessment_id: assessment.id, risk_value: 60) }


  let!(:params)   {ActionController::Parameters.new({
    sub_category_progress_id: sub_category_progress.id,
    assessment_progress_id: assessment_progress.id,
    current_user_id: startup_admin.id,
    startup_id: startup.id
  })}

  let!(:mail)   {AssessmentsMailer.with(params).email_progress_updated_to_admins}
  let!(:mail_2) {AssessmentsMailer.with(params).email_progress_updated_to_startup_users}
  let!(:mail_3) {AssessmentsMailer.with(params).email_progress_updated_to_current_user}

  before do
    params.permit!
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('SENDER_EMAIL').and_return('sender@mail.com')
  end

  describe 'METHOD email_progress_updated_to_admins' do
    it 'renders the subject' do
      expect(mail.subject).to eq("Stage progress of a startup has been updated on RAMP Client Business Planning Support")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([super_admin.email, admins.first.email, admins.second.email, admins.last.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['sender@mail.com'])
    end
  end

  describe 'METHOD email_progress_updated_to_startup_users' do
    it 'renders the subject' do
      expect(mail_2.subject).to eq("The stage progress of your startup has been updated on RAMP Client Business Planning Support")
    end

    it 'renders the receiver email' do
      expect(mail_2.to).to eq([member.email, startup_admin_2.email])
    end

    it 'renders the sender email' do
      expect(mail_2.from).to eq(['sender@mail.com'])
    end
  end

  describe 'METHOD email_progress_updated_to_current_user' do
    it 'renders the subject' do
      expect(mail_3.subject).to eq("You updated the stage progress of your startup on RAMP Client Business Planning Support")
    end

    it 'renders the receiver email' do
      expect(mail_3.to).to eq([startup_admin.email])
    end

    it 'renders the sender email' do
      expect(mail_3.from).to eq(['sender@mail.com'])
    end
  end
end
