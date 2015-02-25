class RemoveLocationableModels < ActiveRecord::Migration
  def up
    drop_table :locations
    drop_table :cities
    drop_table :countries
    drop_table :place_types
    drop_table :places
    drop_table :websites
    drop_table :contact_types
    drop_table :contacts
  end

  def down
    create_table :locations do |t|
      t.references :locationable, polymorphic: true, index: true, null: false
      t.string :name, default: ''
      t.string :address
      t.string :city
      t.string :province
      t.string :country
      t.string :postal_code
      t.float :latitude
      t.float :longitude
      t.integer :zoom_level

      t.timestamps
    end

    create_table :countries do |t|
      t.string :name
      t.text :description
      t.text :wikipedia_url

      t.timestamps
    end

    create_table :cities do |t|
      t.references :country, null: false, index: true
      t.string :name
      t.text :description
      t.text :wikipedia_url

      t.timestamps
    end

    create_table :place_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end

    execute <<-SQL
      INSERT INTO place_types(name) VALUES ('Cafe'), ('Restaurant'), ('Hotel'), ('Hostel'), ('Bed and Breakfast'), ('Airport'), ('Bus Terminal'), ('Hospital'), ('Clinique'), ('Store'), ('Tailor'), ('Gym');
    SQL

    create_table :places do |t|
      t.references :city, index: true, null: false
      t.references :place_type, index: true, null: false
      t.string :name
      t.text :description

      t.timestamps
    end

    create_table :websites do |t|
      t.references :place, index: true, nil: false
      t.string :url, nil: false
      t.string :url_type

      t.timestamps
    end

    create_table :contact_types do |t|
      t.string :name, nil: false
      t.string :description, nil: false

      t.timestamps
    end

    execute <<-SQL
      INSERT INTO contact_types(name, description) VALUES ('email', 'email'), ('phone', 'phone');
    SQL

    create_table :contacts do |t|
      t.references :contact_type, index: true, nil: false
      t.references :place, index: true, nil: false
      t.string :name
      t.string :directions, nil: false
      t.string :direction_type
      t.text :info

      t.timestamps
    end
  end
end
