class ReplaceDataForStartups < ActiveRecord::Migration[6.0]
  def change
    members = Member.all

    members.each do |m|
      AssessmentProgress.where(member_id: m.id)&.update_all(member_id: m.startup_id)
      # assessment_progresses.each { |ap| ap.update(member_id: m.startup_id) }

      SubCategoryProgress.where(member_id: m.id)&.update_all(member_id: m.startup_id)
      # sub_category_progresses.each { |scp| scp.update(member_id: m.startup_id) }
    end

    puts "Data was replaced"
  end
end
