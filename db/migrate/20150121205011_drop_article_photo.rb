class DropArticlePhoto < ActiveRecord::Migration
  def up
    add_column :photos, :article_id, :int, null: true

    if defined? ArticlePhoto
      ArticlePhoto.all.each do |article_photo|
        execute <<-SQL
        UPDATE photos
        SET article_id = #{article_photo.article_id}
        WHERE id = #{article_photo.photo_id}
        SQL
      end
    end

    drop_table :article_photos
  end

  def down
    create_table :article_photos do |t|
      t.integer :article_id
      t.integer :photo_id

      t.timestamps
    end

    execute <<-SQL
      INSERT INTO article_photos('article_id', 'photo_id')
      SELECT photos.article_id, photos.id
      FROM photos
      WHERE article_id IS NOT NULL
    SQL

    remove_column :photos, :article_id
  end
end
