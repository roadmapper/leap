class CreateProperties < ActiveRecord::Migration
  def self.up
    create_table :properties do |t|
      t.string :customer_unique_id
      t.string :owner_name
      t.string :tenant_name
      t.string :street_address
      t.integer :zipcode
      t.integer :plus_four
      t.string :state
      t.string :phone
      t.string :email
      t.date :finish_date
      t.date :consent_date

      t.timestamps
    end
  end

  def self.down
    drop_table :properties
  end
end
