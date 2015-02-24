class RemoveBilletsAndRecipes < ActiveRecord::Migration
  def up
    remove_column :articles, :type
  end

  def down
    add_column :articles, :type, :string

    # All existing articles will be billets for the blog
    execute <<-SQL
      UPDATE articles
      SET type = 'Billet'
    SQL
  end
end
