class DropPhototag < ActiveRecord::Migration
  def up
    drop_table :phototags
  end

  def down
    create_table :phototags do |t|
      t.integer :photo_id
      t.integer :tag_id, null: true

      t.timestamps
    end
  end
end