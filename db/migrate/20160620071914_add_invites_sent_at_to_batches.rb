class AddInvitesSentAtToBatches < ActiveRecord::Migration[6.0]
  def change
    add_column :batches, :invites_sent_at, :datetime
  end
end
