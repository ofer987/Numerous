class FilesizeType < ActiveRecord::Base
  #id: integer, PKEY, NOT NULL
  #name: string, NOT NULL
  #width: integer
  #height: integer
  #created_at: datetime
  #updated_at: datetime
  
  include Lookupable
  
  has_many :fichiers
end
