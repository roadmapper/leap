class CreateRecordings < ActiveRecord::Migration
  def self.up
    create_table :recordings do |t|
      t.string :name
      t.date :read_date
      t.string :consumption
      t.references :utility_type_id
      t.references :act_num
      t.integer :days_in_month

      t.timestamps
    end
  end

  def self.down
    drop_table :recordings
  end
end
