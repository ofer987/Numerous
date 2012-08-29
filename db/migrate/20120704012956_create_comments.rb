class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content, null: false
      t.string :user, null: false

      t.timestamps
    end
  end
end
