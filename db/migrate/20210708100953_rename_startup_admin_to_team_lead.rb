class RenameStartupAdminToTeamLead < ActiveRecord::Migration[6.0]
  def change
    startup_admins = User.where(type: 'StartupAdmin')

    if !startup_admins.empty?
      startup_admins.update_all(type: 'TeamLead')
    end
  end
end
