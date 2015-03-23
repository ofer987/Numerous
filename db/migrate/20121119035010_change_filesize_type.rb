class ChangeFilesizeType < ActiveRecord::Migration
  def up
    if defined? FilesizeType
      thumbnail_type = FilesizeType.select { |type| type.name == 'thumbnail'}.first
      thumbnail_type.width = 250
      thumbnail_type.height = 250
      thumbnail_type.save
    end
  end

  def down
    if defined? FilesizeType
      thumbnail_type = FilesizeType.select { |type| type.name == 'thumbnail'}.first
      thumbnail_type.width = 150
      thumbnail_type.height = 150
      thumbnail_type.save
    end
  end
end
