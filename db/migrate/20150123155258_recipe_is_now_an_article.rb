class RecipeIsNowAnArticle < ActiveRecord::Migration
  def up
    Recipe.all.each do |recipe|
      Article.create(title: recipe.title, sub_title: nil,
                     content: recipe.description, published_at: DateTime.now.utc,
                     type: 'Recipe')
    end

    drop_table :recipes
  end

  def down
    create_table :recipes do |t|
      t.string :title
      t.text :description

      t.timestamps
    end

    # Write into SQL directly because in case
    # the Recipe class is still defined as Single Table Inheritance
    # by being based off the Article class
    Article.where(type: 'Recipe').each do |article|
      execute <<-SQL
        INSERT INTO recipes('title', 'description')
        VALUES ('#{article.title}', '#{article.content}')
      SQL
    end
  end
end
