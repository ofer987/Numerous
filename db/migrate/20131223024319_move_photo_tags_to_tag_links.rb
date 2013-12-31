class MovePhotoTagsToTagLinks < ActiveRecord::Migration
	def up
		execute('insert into tag_links(tag_id, tagable_id, tagable_type)
						select tag_id, photo_id, "Photo"
						from photo_tags')
    
    drop_table :photo_tags
	end

	def down
    create_table :photo_tags do |t|
      t.integer :photo_id
      t.integer :tag_id

      t.timestamps
    end

		execute('insert into photo_tags(tag_id, photo_id)
						select tag_id, tagable_id
						from tag_links
						where tagable_type = "Photo"')
		execute('delete from tag_links')
	end
end
