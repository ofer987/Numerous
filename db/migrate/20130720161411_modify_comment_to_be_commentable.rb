class ModifyCommentToBeCommentable < ActiveRecord::Migration
  def up
    # Comments will be used for multiple tables now instead of just for photos
    change_table :comments do |t|
      t.integer :commentable_id
      t.string :commentable_type
    end

    # move all photo_id values into commentable_id
    execute "update comments set commentable_id = photo_id, commentable_type = 'Photo'"

    # Now we can safely remove the photo_id column
    change_table :comments do |t|
      t.remove :photo_id
    end
  end

  def down
    change_table :comments do |t|
      t.integer :photo_id
    end

    # Move all the foreign key relationships of type photo to the photo_id column
    execute "update comments set photo_id = commentable_id where commentable_type = 'Photo'"

    change_table :comments do |t|
      t.remove :commentable_id, :commentable_type
    end
  end
end
