class CreateUtilityTypes < ActiveRecord::Migration
  def change
    create_table :utility_types do |t|
      t.string :typeName
      t.string :units

      t.timestamps
    end
  end
end
