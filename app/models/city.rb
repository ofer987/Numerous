class City < ActiveRecord::Base
  # id: primary key, NOT NULL
  # country_id: integer, NOT NULL
  # name: varchar(255)
  # created_at: datetime
  # updated_at: datetime

  belongs_to :country

  validates :country, presence: true
end
