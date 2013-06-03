class CreateGazettes < ActiveRecord::Migration
  def change
    create_table :gazettes do |t|
      t.string :name, null: false, default: ''
      t.text :description, null: false, default: ''

      t.timestamps
    end
  end
end
