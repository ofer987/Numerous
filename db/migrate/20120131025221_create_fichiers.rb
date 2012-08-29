class CreateFichiers < ActiveRecord::Migration
  def change
    create_table :fichiers do |t|
      t.integer :photo_id, null: false
      t.string :filename, null: false
      t.integer :filesize_type_id, null: false

      t.timestamps
    end
  end
end
