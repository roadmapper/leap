class CreatePowerRecordings < ActiveRecord::Migration
  def self.up
    create_table :power_recordings do |t|
      t.integer :acctNum
      t.date :readDate
      t.integer :daysElapsed
      t.integer :totalKwh
      t.references :property

      t.timestamps
    end
  end

  def self.down
    drop_table :power_recordings
  end
end
