class CreateConnections < ActiveRecord::Migration[6.0]
  def change
    create_table :connections do |t|
      t.integer :user_id
      t.integer :contact_id
      t.string :direction

      t.timestamps
    end
  end
end
