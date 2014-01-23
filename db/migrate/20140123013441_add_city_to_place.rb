class AddCityToPlace < ActiveRecord::Migration
  def change
    add_column :places, :place, :string
    add_reference :places, :city, index: true
  end
end
