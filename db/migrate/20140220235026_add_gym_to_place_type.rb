class AddGymToPlaceType < ActiveRecord::Migration
  def up
    PlaceType.create!(name: 'Gym')
  end

  def down
    PlaceType.where(name: 'Gym').destroy_all
  end
end
