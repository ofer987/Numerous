class FilesizeType < ActiveRecord::Base
  #id: integer, PKEY, NOT NULL
  #name: string, NOT NULL
  #width: integer
  #height: integer
  #created_at: datetime
  #updated_at: datetime
  
  include Lookupable
  
  validates_presence_of :name, on: :create, :message => "can't be blank"
  validates_uniqueness_of :name, on: :create, message: "must be unique", case_sensitive: false
  
  has_many :fichiers
end
