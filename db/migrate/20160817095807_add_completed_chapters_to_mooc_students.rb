class AddCompletedChaptersToMoocStudents < ActiveRecord::Migration[6.0]
  def change
    add_column :mooc_students, :completed_chapters, :text
  end
end
