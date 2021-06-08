require "rails_helper"

RSpec.describe TasksMailer, type: :mailer do
  let!(:accelerator)      {create(:accelerator, hostname: 'FUZEHUB_HOST')}
  let!(:admin)            {create(:admin, accelerator_id: accelerator.id)}
  let!(:startup)          {create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
  let!(:member)           {create(:member, startup_id: startup.id, accelerator_id: accelerator.id)}
  let!(:member_2)         {create(:member, startup_id: startup.id, accelerator_id: accelerator.id, email_notification: false)}
  let!(:startup_admin)    {create(:startup_admin, startup_id: startup.id, accelerator_id: accelerator.id)}
  let!(:startup_admin_2)  {create(:startup_admin, startup_id: startup.id, accelerator_id: accelerator.id)}
  let!(:startup_admin_3)  {create(:startup_admin, startup_id: startup.id, accelerator_id: accelerator.id, email_notification: false)}
  let!(:assessment)       {create(:assessment)}
    let!(:category)       {create(:category, assessment_id: assessment.id)}
      let!(:sub_category) {create(:sub_category, category_id: category.id)}
        let!(:stage)      {create(:stage, sub_category_id: sub_category.id)}
          let!(:task)     { create(:task, stage_id: stage.id, task_users_attributes: [{user_id: member.id}, {user_id: startup_admin.id}, {user_id: startup_admin_2.id}])}

  let!(:params)   {ActionController::Parameters.new({startup_admins_ids: [startup_admin.id, startup_admin_2.id, startup_admin_3.id], member_id: member.id, task_id: task.id})}
  let!(:params_2) {ActionController::Parameters.new({users_ids: [member.id, member_2.id], task_id: task.id})}

  let!(:mail)   {TasksMailer.with(params).email_task_completed}
  let!(:mail_2) {TasksMailer.with(params_2).email_users_assigned}

  before do
    params.permit!
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('SENDER_EMAIL').and_return('sender@mail.com')
  end

  describe 'METHOD email_task_completed' do
    it 'renders the subject' do
      expect(mail.subject).to eq("User of your startup completed task on RAMP Client Business Planning support tool")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([startup_admin.email, startup_admin_2.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['sender@mail.com'])
    end
  end

  describe 'METHOD email_users_assigned' do
    it 'renders the subject' do
      expect(mail_2.subject).to eq("You have been assigned to a task on RAMP Client Business Planning support tool")
    end

    it 'renders the receiver email' do
      expect(mail_2.to).to eq([member.email])
    end

    it 'renders the sender email' do
      expect(mail_2.from).to eq(['sender@mail.com'])
    end
  end
end
