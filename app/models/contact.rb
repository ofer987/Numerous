class Contact < ActiveRecord::Base
  # id: integer, primary key, not nil
  # contact_type: integer, foreign key, not nil
  # directions: nvarchar(255), not nil
  # direction_type: nvarchar(255)
  # info: text

  belongs_to :contact_type
  belongs_to :place

  validates :contact_type, 
    presences: { allow_nil: false, allow_blank: false }
  validates :place, 
    presences: { allow_nil: false, allow_blank: false }
  validates :directions, 
    presences: { allow_nil: false, allow_blank: false }
end
