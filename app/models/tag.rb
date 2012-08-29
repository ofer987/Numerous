class Tag < ActiveRecord::Base
  #id: integer, PKEY, NOT NULL
  #name: string, NOT NULL, default: ""
  #created_at: datetime
  #updated_at: datetime
  
  include Tagable
  
  attr_accessible :name
  
  has_many :photo_tags, dependent: :delete_all
  has_many :photos, through: :photo_tags
  
  validates_presence_of :name, on: :create, :message => "can't be blank"
  validates_uniqueness_of :name, on: :create, message: "must be unique", case_sensitive: false
end
