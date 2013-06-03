class Article < ActiveRecord::Base
  # id: integer, PKEY, NOT NULL
  # gazette_id: integer, PKEY, FKEY, NOT NULL
  # title: string, NOT NULL, Default ''
  # sub_title: string
  # content: text, NOT NULL, Default ''
  # updated_at: datetime
  # created_at: datetime

  attr_accessible :gazette_id, :title, :sub_title, :content
  
  belongs_to :gazette
end
