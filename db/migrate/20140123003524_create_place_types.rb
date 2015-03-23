class CreatePlaceTypes < ActiveRecord::Migration
  def change
    create_table :place_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end

    if defined? PlaceType
      PlaceType.create!(name: 'Cafe')
      PlaceType.create!(name: 'Restaurant')
      PlaceType.create!(name: 'Hotel')
      PlaceType.create!(name: 'Hostel')
      PlaceType.create!(name: 'Bed and Breakfast')
      PlaceType.create!(name: 'Airport')
      PlaceType.create!(name: 'Bus Terminal')
    end
  end
end
