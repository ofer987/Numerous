class AddPhotoIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :photo_id, :int, null: false, default: ""
  end
end
