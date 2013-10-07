class ChangeArticlePublishedAt < ActiveRecord::Migration
  def up
    # The default published_at datetime should be computed when a row is created
    # Therefore it is set in the model's before_validation
    change_column_default :articles, :published_at, nil
  end

  def down
    change_column_default :articles, :published_at, DateTime.now
  end
end
