class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :locationable, polymorphic: true, index: true, null: false
      t.string :name, default: ''
      t.string :address
      t.string :city
      t.string :province
      t.string :country
      t.string :postal_code
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
