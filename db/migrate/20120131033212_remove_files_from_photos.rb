class RemoveFilesFromPhotos < ActiveRecord::Migration
  def up
    remove_column :photos, :filename
    remove_column :photos, :thumbnail
  end

  def down
    add_column :photos, :thumbnail, :string
    add_column :photos, :filename, :string
  end
end
