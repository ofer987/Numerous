class ChangeCommentPhotoId < ActiveRecord::Migration
  def up
    change_column :comments, :photo_id, :int, null: true, default: nil
  end

  def down
    change_column :comments, :photo_id, :int, null: false, default: ""
  end
end
