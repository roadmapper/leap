class CreatePropertyMeasures < ActiveRecord::Migration
  def change
    create_table :property_measures do |t|
      t.references :property
      t.references :measure
      t.text :comment

      t.timestamps
    end
    add_index :property_measures, :property_id
    add_index :property_measures, :measure_id
  end
end
