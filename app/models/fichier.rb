class Fichier < ActiveRecord::Base
  #id: integer, PKEY, NOT NULL
  #photo_id: integer, FKEY, NOT NULL
  #filesize_type_id: integer, FKEY, NOT NULL
  #created_at: datetime
  #updated_at: datetime
  
  belongs_to :photo
  belongs_to :filesize_type
  
  before_validation :ensure_filesize_type_exists
  before_validation :ensure_belongs_to_photo
  
  before_destroy :before_destroy
  
  attr_accessor :saved_image

  after_save :write_file
  
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
  
  def before_destroy
    if File.delete(File.join(self.photo.photo_store + self.filename)) == 0
      raise "Could not delete file or file not found: #{fichier.filename}\n"
    end 
  end
  
  private
    def write_file
      resized_image = self.saved_image

      begin
        # resize the image unless photosize is original
        unless self.photosize.name == 'original'
          resized_image = self.saved_image.resize_to_fit(self.photosize.width, self.photosize.height)
        end

        # write the image to file
        resized_image.write(self.absolute_filename)
      rescue
        return false
      ensure
        self.saved_image = nil
      end
    end
end
