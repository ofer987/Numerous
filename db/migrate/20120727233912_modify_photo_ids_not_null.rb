class ModifyPhotoIdsNotNull < ActiveRecord::Migration
  def up
    change_column :comments, :photo_id, :int, null: false, default: ""
    change_column :photo_tags, :photo_id, :int, null: false, default: ""
    change_column :photo_tags, :tag_id, :int, null: false, default: ""
  end

  def down
    change_column :comments, :photo_id, :int, null: true
    change_column :photo_tags, :photo_id, :int, null: true
    change_column :photo_tags, :tag_id, :int, null: true
  end
end
