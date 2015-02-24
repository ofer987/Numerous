class User < ActiveRecord::Base
  #id: integer, PKEY, NOT NULL
  #name: varchar(255), NOT NULL
  #password_digest: varchar(255), NOT NULL
  #created_at: datetime
  #updated_at: datetime

  has_many :articles

  validates :name, presence: true, uniqueness: true

  has_secure_password
end
