class CreateRecordings < ActiveRecord::Migration
  def change
    create_table :recordings do |t|
      t.integer :acctnum
      t.date :read_date
      t.string :consumption
      t.integer :days_in_month
      t.references :utility_type

      t.timestamps
    end
    add_index :recordings, :utility_type_id
  end
end
