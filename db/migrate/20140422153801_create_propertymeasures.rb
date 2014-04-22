class CreatePropertymeasures < ActiveRecord::Migration
  def change
    create_table :propertymeasures do |t|
      t.references :property
      t.references :installed_measure_type
      t.text :comment

      t.timestamps
    end
    add_index :propertymeasures, :property_id
    add_index :propertymeasures, :installed_measure_type_id
  end
end
