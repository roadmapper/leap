class AddUtilityCompanyToRecordLookups < ActiveRecord::Migration
  def change
    add_column :record_lookups, :company_name, :string
  end
end
