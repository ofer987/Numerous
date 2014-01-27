class Country < ActiveRecord::Base
  # id: primary key, NOT NULL
  # name: varchar(255)
  # created_at: datetime
  # updated_at: datetime

  has_many :locations, as: :locationable, dependent: :destroy
  has_many :cities

  validates :name, uniqueness: true, presence: true
end
