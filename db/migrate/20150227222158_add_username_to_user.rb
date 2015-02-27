class AddUsernameToUser < ActiveRecord::Migration
  def up
    add_column :users, :username, :string, null: true

    execute <<-SQL
      UPDATE users
      SET username = users.name
    SQL

    change_column :users, :username, :string, null: false
  end

  def down
    remove_column :users, :username
  end
end
