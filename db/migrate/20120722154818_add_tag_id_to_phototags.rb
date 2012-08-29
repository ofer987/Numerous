class AddTagIdToPhototags < ActiveRecord::Migration
  def up
    add_column :phototags, :tag_id, :int, null: true
    remove_column :phototags, :name
  end
  
  def down
    remove_column :phototags, :tag_id
    add_column :phototags, :name, :string, null: false, default: ""
  end
end
