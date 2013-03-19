class PhotoTag < ActiveRecord::Base
  #id: integer PKEY, NOT NULL
  #photo_id: integer, FKEY, NOT NULL
  #tag_id: integer, FKEY, NOT NULL
  
  #validates_inclusion_of :photo_id, :in => Photo.all.map { |photo| photo.id }, :on => :create, :message => "Join table should reference a valid photo"
  #validates_inclusion_of :tag_id, :in => Tag.all.map { |tag| tag.id }, :on => :create, :message => "Join table should reference a valid tag"
  #validates_presence_of :photo_id, :on => :create, :message => "must belong to a photo"
  validates_presence_of :tag_id, :on => :create, :message => "must belong to a tag"
  validates_uniqueness_of :tag_id, scope: :photo_id, :on => :create, :message => "a photo can only have unique tags"
  after_destroy :delete_tag
  
  belongs_to :photo
  belongs_to :tag
  
  attr_accessible :photo_id, :tag_id
  
  private
  
  def delete_tag
    # Delete the the tag if it is no longer used
    if !PhotoTag.any? { |photo_tag| photo_tag.tag_id == self.tag_id }
      Tag.find_by_id(self.tag_id).delete
    end
  end
end
