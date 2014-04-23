class CreatePropertyMeasures < ActiveRecord::Migration
  def change
    create_table :property_measures do |t|
      t.references :property, :null => false
      t.references :installed_measure_type
      t.text :comments

      t.timestamps
    end
    add_index :property_measures, :property_id
    add_index :property_measures, :installed_measure_type_id
  end
end
