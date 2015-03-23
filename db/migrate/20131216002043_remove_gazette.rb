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

    if defined? Gazette
      gazette = Gazette.create(name: 'default')
    end

    change_table :articles do |t|
      t.integer :gazette_id, null: true
    end

    if defined? Article
      Article.all.each do |article|
        article.gazette_id = gazette.id
        article.save!
      end
    end

    change_table :articles do |t|
      t.change :gazette_id, :integer, null: false
    end
  end
end
