class Photo < ActiveRecord::Base
  #id: integer, PKEY, NOT NULL
  #title: varchar(255), NOT NULL
  #description: text, NOT NULL, DEFAULT: ''
  #filename: varchar(255), NOT NULL
  #taken_date: datetime, NOT NULL, DEFAULT: DateTime.current
  #created_at: datetime
  #updated_at: datetime

  default_scope { order('taken_date DESC') }

  has_many :tag_links, as: :tagable, dependent: :destroy
  has_many :tags, through: :tag_links
  include Tagable

  has_many :fichiers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  belongs_to :article

  after_initialize :set_description
  after_initialize :set_title

  validates_presence_of :article_id
  validates_presence_of :description, allow_blank: true
  validates_presence_of :title, allow_blank: true
  validates_presence_of :filename, on: :create,
    :message => "must be specified"
  validates_presence_of :taken_date, on: :create,
    :message => "must have a date, at least a default one"
  validates_format_of :filename, :with => /\.(jpg|png)\z/i,
    :message => "is invalid"

  validate :validate_has_unique_fichiers

  before_create :before_create
  before_update :before_update

  # Root directory of the photo public/photos
  def photo_store
    Rails.root.join('public', 'images', 'photos')
  end

  def method_missing(name, *args, &block)
    if name =~ /(\w+)_fichier/
      self.fichiers.find_by_filesize_type_id(FilesizeType[$1])
    else
      super(name, *args, &block)
    end
  end

  # "f.file_field :load_photo_file" in the view triggers Rails to invoke this method
  # This method only store the information
  # The file saving is done in before_save
  def load_photo_file=(data)
    raise 'Error: File is not an image' unless data.content_type.match(/image\/jpe?g/)
    if data.respond_to? ('original_filename')
      filename = data.original_filename
    else
      raise 'Error: file does not have a filename'
    end

    # Store the data for later use
    self.filename = filename
    @photo_data = data
  end

  def set_description
    self.description ||= ''
  end

  def set_title
    self.title ||= ''
  end

  def rotate!
    self.fichiers.each do |fichier|
      fichier.rotate!
    end
  end

  def displayed_title
    title.blank? ? '&nbsp;' : title
  end

  private

  def before_update
    write_file unless @photo_data.nil?
  end

  def before_create
    return false if @photo_data.nil?

    write_file
  end

  def filename=(new_filename)
    /^([^\.]+)\.(jpg|png)/i =~ new_filename
    new_filename_simple = $1
    new_filename_extension = $2

    # If another photo already uses the same file,
    # then add a number to the end of the filename untill unique
    i = 0
    while true
      existing_full_filename = File.join(self.photo_store, new_filename)

      if File.exists?(existing_full_filename)
        i=i+1
        new_filename = "#{new_filename_simple}_#{i.to_s}.#{new_filename_extension}"
      else
        break
      end
    end

    self[:filename] = new_filename
  end

  def write_file
    # Load the image
    begin
      @saved_image = Magick::ImageList.new(@photo_data.tempfile.path)
    rescue Exception => e
      errors.add(:base, e.message)
      return false
    end

    # Set the metadata
    set_metadata

    # Create files of different sizes and fichier relationships
    set_fichiers

    # Clear the image data from application memory
    @photo_data = nil
  end

  # Store the date the image as taken
  # Default date is DateTime.current (UTC)
  def set_metadata
    image_datetime = @saved_image.get_exif_by_entry('DateTime')[0][1]
    image_datetime = @saved_image.get_exif_by_entry('DateTimeOriginal')[0][1] if image_datetime.nil?
    self.taken_date = image_datetime.nil? ? DateTime.current : DateTime.strptime(image_datetime, '%Y:%m:%d %H:%M:%S')
  end

  def set_fichiers
    FilesizeType.all.each do |filesize_type|
      case filesize_type.name
        when 'original'
          # Always create a fichier record in the db
          self.fichiers.build(filesize_type: filesize_type, saved_image: @saved_image)
        when 'thumbnail'
          # Always create a small version of this photo,
          self.fichiers.build(filesize_type: filesize_type, saved_image: @saved_image)
        else
          # Created the other fichiers if their dimensions satisfy the size requirements
          if filesize_type.width < @saved_image.columns or filesize_type.height < @saved_image.rows then
            self.fichiers.build(filesize_type: filesize_type, saved_image: @saved_image)
          end
      end
    end
  end

  def validate_has_unique_fichiers
    self.fichiers.each do |verify1|
      self.fichiers.each do |verify2|
        next if verify1 == verify2
        if verify1.filesize_type == verify2.filesize_type
          errors.add(:base, "duplicate fichiers of type #{verify1.filesize_type.name}")
          return
        end
      end
    end
  end
end
