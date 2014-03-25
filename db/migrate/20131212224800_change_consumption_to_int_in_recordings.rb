class ChangeConsumptionToIntInRecordings < ActiveRecord::Migration
  def change
    change_column :recordings, :consumption, :float
  end
end
