class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.references :place, index: true, nil: false
      t.string :url, nil: false
      t.string :url_type

      t.timestamps
    end

    remove_column :places, :home_url, :string
    remove_column :places, :wikipedia_url, :string
  end
end
