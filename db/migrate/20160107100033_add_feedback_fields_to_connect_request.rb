class AddFeedbackFieldsToConnectRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :connect_requests, :feedback_mails_sent_at, :datetime
    add_column :connect_requests, :rating_of_faculty, :integer
    add_column :connect_requests, :rating_of_team, :integer
  end
end
