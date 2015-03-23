class CreateContactTypes < ActiveRecord::Migration
  def change
    create_table :contact_types do |t|
      t.string :name, nil: false
      t.string :description, nil: false

      t.timestamps
    end

    if defined? ContactType
      ContactType.create!(name: 'email', description: 'email')
      ContactType.create!(name: 'phone', description: 'phone')
    end
  end
end
