class ChangePhotoColumnDescriptionDefault < ActiveRecord::Migration
  def up
    # Empty values are allowed for description
    change_column_default :photos, :description, ''

    # The photo should have a filename: nil values should not be allowed
    change_column_null :photos, :filename, false
    change_column_default :photos, :filename, nil
  end

  def down
    change_column_default :photos, :description, nil
    change_column_null :photos, :filename, false # Previous setting
    change_column_default :photos, :filename, ''
  end
end
