class AddCityToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :city, :string
  end
end
