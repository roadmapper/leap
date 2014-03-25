class CreateRecordLookups < ActiveRecord::Migration
  def change
    create_table :record_lookups do |t|
      t.references :property
      t.references :utility_type
      t.string :acct_num

      t.timestamps
    end
    add_index :record_lookups, :property_id
    add_index :record_lookups, :utility_type_id
  end
end
