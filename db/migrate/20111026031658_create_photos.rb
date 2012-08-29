class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :thumbnail, null: false
      t.string :filename, null: false
      t.datetime :taken_date, null: false, default: DateTime.current

      t.timestamps
    end
  end
end
