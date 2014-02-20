class CreateContacts < ActiveRecord::Migration
  def change
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
