class AddCountryToCity < ActiveRecord::Migration
  def change
    add_column :cities, :city, :string
    add_reference :cities, :country, index: true
  end
end
