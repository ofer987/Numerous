class AddGymToPlaceType < ActiveRecord::Migration
  def up
    if defined? PlaceType
      PlaceType.create!(name: 'Gym')
    end
  end

  def down
    if defined? PlaceType
      PlaceType.where(name: 'Gym').destroy_all
    end
  end
end
