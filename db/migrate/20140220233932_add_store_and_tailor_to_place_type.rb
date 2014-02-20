class AddStoreAndTailorToPlaceType < ActiveRecord::Migration
  def up
    PlaceType.create!(name: 'Store')
    PlaceType.create!(name: 'Tailor')
  end

  def down
    PlaceType.where(name: 'Store').destroy_all
    PlaceType.where(name: 'Tailor').destroy_all
  end
end
