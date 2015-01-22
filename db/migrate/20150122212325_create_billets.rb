class CreateBillets < ActiveRecord::Migration
  def up
    add_column :articles, :type, :string

    # All existing articles will be billets for the blog
    execute <<-SQL
      UPDATE articles
      SET type = 'Billet'
    SQL
  end

  def down
    # All billets are represented uniquely by the article model
    remove_column :article, :type
  end
end
