class DropBanks < ActiveRecord::Migration[6.0]
    drop_table :banks
  end

  def self.down
    create_table :banks do |t|
      t.string   "mode_of_operation"
      t.integer  "startup_id"
      t.timestamps
  end
end
