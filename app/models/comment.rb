class Comment < ActiveRecord::Base
  #id: integer PKEY, NOT NULL
  #photo_id: integer, FKEY, NOT NULL
  #content: text, NOT NULL
  #user: string, NOT NULL
  #created_at: datetime
  #updated_at: datetime
  
  belongs_to :photo
  
  validates_length_of :content, minimum: 1, allow_nil: false, allow_blank: false, message: "must be present"
  validates_length_of :user, minimum: 1, allow_nil: false, allow_blank: false, message: "must be present"
  #validates_inclusion_of :photo_id, :in => Photo.all.map { |photo| photo.id }, :on => :create, :message => "does not exist"
  
  before_validation :photo_exists?
  
  private
  
  def photo_exists?
    if Photo.all.any? { |photo| photo.id == self.photo_id }
      true
    else
      errors.add(:base, "Photo #{self.photo_id} does not exist")
      false
    end
  end
end
