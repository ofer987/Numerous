class AddHospitalToPlaceType < ActiveRecord::Migration
  def up
    if defined? PlaceType
      PlaceType.create!(name: 'Hospital')
      PlaceType.create!(name: 'Clinique')
    end
  end

  def down
    if defined? PlaceType
      PlaceType.where(name: 'Hospital').destroy_all
      PlaceType.where(name: 'Clinique').destroy_all
    end
  end
end
