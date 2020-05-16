class RemoveColumnPhoneVerifiedFromUser < ActiveRecord::Migration[6.0]
  def up
    remove_column :users, :phone_verified
  end

  def down
    add_column :users, :phone_verified, :boolean, default: false
  end
end
