class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.references :country, null: false, index: true
      t.string :name

      t.timestamps
    end
  end
end
