class CreateFilesizeTypes < ActiveRecord::Migration
  def up
    create_table :filesize_types do |t|
      t.string :name, null: false
      t.integer :width
      t.integer :height

      t.timestamps
    end

    FilesizeType.create!(name: 'original')
    FilesizeType.create!(name: 'thumbnail',  width: 150,   height: 150)
    FilesizeType.create!(name: 'large',      width: 2000,  height: 2000)
    FilesizeType.create!(name: 'medium',     width: 1000,  height: 1000)
    FilesizeType.create!(name: 'small',      width: 800,   height: 800)
  end

  def down
    drop_table :filesize_types
  end
end
