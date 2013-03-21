class Tag < ActiveRecord::Base
  #id: integer, PKEY, NOT NULL
  #name: string, NOT NULL, default: ""
  #created_at: datetime
  #updated_at: datetime
  
  include Tagable
  
  attr_accessible :name
  
  has_many :photo_tags, dependent: :delete_all
  has_many :photos, through: :photo_tags
  
  def to_tag_param_sym
    "tag_#{self.name}".to_sym
  end
end
