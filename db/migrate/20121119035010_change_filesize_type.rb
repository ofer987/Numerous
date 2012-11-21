class ChangeFilesizeType < ActiveRecord::Migration
  def up
    thumbnail_type = FilesizeType.first { |type| type.name == 'thumbnail'}
    thumbnail_type.width = 250
    thumbnail_type.height = 250
    thumbnail_type.save
  end

  def down
    thumbnail_type = FilesizeType.first { |type| type.name == 'thumbnail'}
    thumbnail_type.width = 150
    thumbnail_type.height = 150
    thumbnail_type.save
  end
end
