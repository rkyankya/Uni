class AddTimestampToPublicSlackMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :public_slack_messages, :timestamp, :string
  end
end
