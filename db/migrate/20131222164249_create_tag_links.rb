class CreateTagLinks < ActiveRecord::Migration
  def change
    create_table :tag_links do |t|
      t.references :tag, index: true
      t.references :tagable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
