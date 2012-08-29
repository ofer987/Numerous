class Fichier < ActiveRecord::Base
  #id: integer, PKEY, NOT NULL
  #photo_id: integer, FKEY, NOT NULL
  #filesize_type_id: integer, NOT NULL
  #created_at: datetime
  #updated_at: datetime
  
  belongs_to :photo
  belongs_to :filesize_type
  
  before_validation :ensure_filesize_type_exists
  before_validation :ensure_belongs_to_photo
  
  #validates_inclusion_of :filesize_type_id, :in => FilesizeType.all.map { |type| type.id }, :on => :create, :message => "should use a valid FilesizeType"
  
  # get the filename
  def filename
    if (self.filesize_type.name == 'original')
      self.photo.filename
    else
      /^([^\.]+)\.(jpg|png)/i =~ self.photo.filename
      $1 + "_" + self.filesize_type.name + "." + $2
    end
  end
  
  def find_by_filesize_type(name)
    self.find_by_filesize_type_id(FilesizeType.find_by_name(name))
  end
  
  private
  
  def ensure_filesize_type_exists
    if FilesizeType.all.any? { |filesize_type| filesize_type.id == self.filesize_type_id }
      true
    else
      errors.add(:base, "FilesizeType does not exist")
      false
    end
  end
  
  def ensure_belongs_to_photo
    if Photo.all.any? { |photo| photo.id == self.photo_id }
      true
    else
      errors.add(:base, "Photo does not exist")
      false
    end
  end
end
