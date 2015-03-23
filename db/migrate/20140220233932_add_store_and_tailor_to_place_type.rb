class AddStoreAndTailorToPlaceType < ActiveRecord::Migration
  def up
    if defined? PlaceType
      PlaceType.create!(name: 'Store')
      PlaceType.create!(name: 'Tailor')
    end
  end

  def down
    if defined? PlaceType
      PlaceType.where(name: 'Store').destroy_all
      PlaceType.where(name: 'Tailor').destroy_all
    end
  end
end
