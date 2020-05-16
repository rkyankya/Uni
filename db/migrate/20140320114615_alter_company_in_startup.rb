class AlterCompanyInStartup < ActiveRecord::Migration[6.0]
  def self.up
    remove_column(:startups, :company)
    add_column(:startups, :company_names, :text)
  end

  def self.down
    remove_column(:startups, :company_names)
    add_column(:startups, :company, :text)
  end
end
