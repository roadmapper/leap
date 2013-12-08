class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :file_name
      t.string :status
      t.datetime :upload_date
      t.string :status
      t.datetime :process_date
      t.string :uploaded_by

      t.timestamps
    end
  end
end
