class CorrectMoocStudentIdInQuizAttempts < ActiveRecord::Migration[6.0]
  def self.up
    change_column :quiz_attempts, :mooc_student_id, 'integer USING CAST(mooc_student_id AS integer)'
  end

  def self.down
    change_column :quiz_attempts, :mooc_student_id, :string
  end
end
