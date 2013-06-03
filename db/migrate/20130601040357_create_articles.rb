class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :gazette_id, null: false
      t.string :title, null: false, default: ''
      t.string :sub_title, null: true
      t.text :content, null: false, default: ''

      t.timestamps
    end
  end
end
