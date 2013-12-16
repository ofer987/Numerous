class RemoveGazette < ActiveRecord::Migration
  def up
    change_table :articles do |t|
      t.remove :gazette_id
    end
    
    drop_table :gazettes
  end
  
  def down
    create_table :gazettes do |t|
      t.string :name, null: false, default: ''
      t.text :description, null: false, default: ''

      t.timestamps
    end
    
    gazette = Gazette.create(name: 'default')
    
    change_table :articles do |t|
      t.integer :gazette_id, null: true
    end
    
    Article.all.each do |article|
      article.gazette_id = gazette.id
      article.save!
    end
    
    change_table :articles do |t|
      t.change :gazette_id, :integer, null: false
    end
  end
end
