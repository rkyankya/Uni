class AddStartupFormLinkSentStatusToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :startup_form_link_sent_status, :boolean
  end
end
