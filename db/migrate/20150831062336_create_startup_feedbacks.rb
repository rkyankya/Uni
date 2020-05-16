class CreateStartupFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :startup_feedbacks do |t|
      t.text :feedback
      t.string :reference_url

      t.timestamps null: false
    end
  end
end
