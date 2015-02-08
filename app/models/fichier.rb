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

  before_save :write_file

  # get the filename
  def filename
    if (self.filesize_type.name == 'original')
      self.photo.filename
    else
      /^([^\.]+)\.(jpg|png)/i =~ self.photo.filename
      $1 + "_" + self.filesize_type.name + "." + $2
    end
  end

  def absolute_filename
    File.join(self.photo.photo_store, self.filename)
  end

  def find_by_filesize_type(name)
    self.find_by_filesize_type_id(FilesizeType.find_by_name(name))
  end

  def rotate!
    begin
      image = Magick::ImageList.new(self.absolute_filename)
    rescue Exception => e
      errors.add(:base, "Could not open the file #{self.absolute_filename} to rotate")
    end

    image.rotate!(90)
    if image == nil
      errors.add(:base, "Failed to rotate the image #{self.absolute_filename}")
    else
      begin
        image.write(self.absolute_filename)
      rescue Exception => e
        errors.add(:base, "Failed to save the rotated image #{self.absolute_filename}")
      end
    end
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
    begin
      File.delete(File.join(self.photo.photo_store + self.filename))
    rescue Exception => e
      errors.add(:base, e.message)
      return false
    end
  end

  def write_file
    resized_image = self.saved_image

    begin
      # resize the image unless filesize_type is original
      unless self.filesize_type.name == 'original'
        resized_image = self.saved_image.resize_to_fit(self.filesize_type.width, self.filesize_type.height)
      end

      # write the image to file
      resized_image.write(self.absolute_filename)
    rescue Exception => e
      errors.add(:base, e.message)
      return false
    ensure
      self.saved_image = nil
    end
  end
end
