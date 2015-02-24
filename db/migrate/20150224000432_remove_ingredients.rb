class RemoveIngredients < ActiveRecord::Migration
  def up
    drop_table :ingredients
  end

  def down
    create_table :ingredients do |t|
      t.string :name
      t.string :quantity
      t.references :recipe, index: true

      t.timestamps
    end
  end
end
