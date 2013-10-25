class CreateGasRecordings < ActiveRecord::Migration
  def self.up
    create_table :gas_recordings do |t|
      t.integer :acctNum
      t.string :name
      t.string :address
      t.date :readDate
      t.integer :consumption
      t.references :property

      t.timestamps
    end
  end

  def self.down
    drop_table :gas_recordings
  end
end
