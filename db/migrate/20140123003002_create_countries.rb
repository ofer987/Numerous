class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name
      t.text :description
      t.text :wikipedia_url

      t.timestamps
    end
  end
end
