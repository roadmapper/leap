class CreateUtilityTypes < ActiveRecord::Migration
  def self.up
    create_table :utility_types do |t|
      t.string :typeName
      t.string :units
      t.string :acctNum

      t.timestamps
    end
  end

  def self.down
    drop_table :utility_types
  end
end
