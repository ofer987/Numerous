class DropPhototag < ActiveRecord::Migration
  def up
    drop_table :phototags
  end

  def down
    create_table :phototags do |t|
      t.integer :photo_id
      t.intger :tag_id, null: true
      t.string :name

      t.timestamps
    end
  end
end