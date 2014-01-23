class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.references :place_type, index: true

      t.timestamps
    end
  end
end
