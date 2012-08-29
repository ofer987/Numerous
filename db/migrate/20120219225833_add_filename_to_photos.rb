class AddFilenameToPhotos < ActiveRecord::Migration
  def up
    add_column :photos, :filename, :string, null: false, default: ''
    
    remove_column :fichiers, :filename
  end
  
  def down
    remove_column :photos, :filename
    
    add_column :fichiers, :filename, :string, null: false, default: ''
  end
end
