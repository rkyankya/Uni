class AddContactEmailToStartupJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :startup_jobs, :contact_email, :string
  end
end
