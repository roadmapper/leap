class RemoveAcctNumFromUtilityTypes < ActiveRecord::Migration
  def up
    remove_column :utility_types, :acctNum
  end

  def down
    add_column :utility_types, :acctNum, :integer
  end
end
