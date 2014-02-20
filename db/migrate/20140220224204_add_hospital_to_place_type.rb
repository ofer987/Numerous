class AddHospitalToPlaceType < ActiveRecord::Migration
  def up
    PlaceType.create!(name: 'Hospital')
    PlaceType.create!(name: 'Clinique')
  end

  def down
    PlaceType.where(name: 'Hospital').destroy_all
    PlaceType.where(name: 'Clinique').destroy_all
  end
end
