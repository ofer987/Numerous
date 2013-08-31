class AddPublishedAtToArticle < ActiveRecord::Migration
  def up
    add_column :articles, :published_at, :datetime, { null: false, default: DateTime.now }

    # Move the datetime from created_at to published_at
    # Previously, created_at used to define the time an article was published.
    # However, this field should be used for when the database row was created,
    # regardless of when the article was published in time.
    execute("update articles set published_at = created_at")
  end

  def down
    # Previously, the created_at field was used to indicate the time an article was published at
    execute("update articles set created_at = published_at")

    remove_column :articles, :published_at
  end
end
