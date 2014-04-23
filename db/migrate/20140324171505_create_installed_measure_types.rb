class CreateInstalledMeasureTypes < ActiveRecord::Migration
  def change
    create_table :installed_measure_types do |t|
      t.string :installed_measures

      t.timestamps
    end
  end
end
