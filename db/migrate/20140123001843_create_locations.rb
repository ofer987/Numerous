class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name, default: ''
      t.string :address
      t.string :city
      t.string :country
      t.string :postal_code
      t.string :coordinates

      t.timestamps
    end

    add_reference :locations, :locationable, polymorphic: true, index: true
  end
end
