class ContactType < ActiveRecord::Base
  # id: primary key, not nil
  # name: nvarchar(255), not nil
  # description: text

  validates :name, presence: { allow_blank: false, allow_nil: false }
  validates :description, presence: { allow_blank: false, allow_nil: false }
end
