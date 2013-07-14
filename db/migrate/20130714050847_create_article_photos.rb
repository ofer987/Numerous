class CreateArticlePhotos < ActiveRecord::Migration
  def change
    create_table :article_photos do |t|
      t.integer :article_id
      t.integer :photo_id

      t.timestamps
    end
  end
end
