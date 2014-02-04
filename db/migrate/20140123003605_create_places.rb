class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.references :city, index: true, null: false
      t.references :place_type, index: true, null: false
      t.string :name
      t.text :description
      t.string :wikipedia_url
      t.string :home_url

      t.timestamps
    end
  end
end
