class AddUserSmsSentAtToMentorMeeting < ActiveRecord::Migration[6.0]
  def change
    add_column :mentor_meetings, :user_sms_sent_at, :datetime
  end
end
