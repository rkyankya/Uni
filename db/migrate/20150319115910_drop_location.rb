class DropLocation < ActiveRecord::Migration[6.0]
  def change
    drop_table :locations
  end
end
