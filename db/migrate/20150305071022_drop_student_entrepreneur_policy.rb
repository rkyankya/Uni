class DropStudentEntrepreneurPolicy < ActiveRecord::Migration[6.0]
  def change
    drop_table :student_entrepreneur_policies
  end
end
