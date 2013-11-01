class Photo < ActiveRecord::Base
  #id: integer, PKEY, NOT NULL
  #title: varchar(255), NOT NULL
  #description: text, NOT NULL, DEFAULT: ''
  #filename: varchar(255), NOT NULL
  #taken_date: datetime, NOT NULL, DEFAULT: DateTime.current
  #created_at: datetime
  #updated_at: datetime
  
  has_many :photo_tags, dependent: :destroy
  has_many :tags, through: :photo_tags
  
  has_many :fichiers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  
  has_many :article_photos, dependent: :delete_all
  has_many :articles, through: :article_photos

  after_initialize :set_description

  validates_presence_of :description, allow_blank: true
  validates_length_of :title, minimum: 1, allow_nil: false, allow_blank: false, :message => "must be present"
  validates_presence_of :filename, on: :create, :message => "must be specified"
  validates_presence_of :taken_date, on: :create, :message => "must have a date, at least a default one"
  validates_format_of :filename, :with => /\.(jpg|png)\z/i, :message => "is invalid"
  
  validate :validate_has_unique_fichiers
  
  #validates_format_of :taken_date, :with => /^\d\d\d\d-\d\d-\d\d\s\d\d:\d\d:\d\d$/, :on => :create, 
  #  :message => "is invalid, needs to be in date format YYYY-MM-DD HH:MM:SS"
 
  before_create :before_create
  before_update :before_update

  # Root directory of the photo public/photos
  def photo_store
    Rails.root.join('app', 'assets', 'images', 'photos')
  end

  def tags_attributes=(attributes)
    add_remove_tags(attributes)
  end
  
  def new_tags=(new_tags)
    new_tags ||= ""
    tag_names = new_tags.split(",")
    
    # Add tags
    tag_names.each do |name|
      name = name.strip.downcase
      
      # Create a new tag if it does not already exist
      tag = Tag[name] || Tag.create(name: name)
      
      # Add the tag to this photo's tag collection unless it already exists in it
      unless self.photo_tags.find_by_tag_id(tag.id)
        self.photo_tags.build { |photo_tag| photo_tag.tag_id = tag.id }
      end
    end
  end

  def any_selected_tag_names?(tag_names)
    if (tag_names != nil and !tag_names.empty?)
      self.tags.any? { |tag| tag_names.any? { |selected_tag_name| Tag.name_equals?(selected_tag_name, tag.name) } }
    else
      self
    end
  end

  def add_tag(name)
    # Remove whitespace
    name.strip!
    
    existing_tag = Tag.first(conditions: ["lower(name) = ?", name.downcase])
    
    if self.tags.first(conditions: ["lower(name) = ?", name.downcase])
      raise "Photo already has a tag with this name"
    elsif existing_tag != nil
      self.photo_tags.create(tag_id: existing_tag.id)
    else
      self.tags.create(name: name)
    end
  end
  
  def delete_tag(name)
    self.tags.delete(Tag.first(conditions: ["lower(name) = ?", name.downcase]))
  end

	def select_fichier(name)
	  self.fichiers.find_by_filesize_type_id(FilesizeType[name])
	end
	
	def add_fichier(name)
	  if (self.select_fichier(name) == nil)
	    self.fichiers.create(filesize_type: FilesizeType[name])
    else
      self.select_fichier(name)
    end
	end
 
  # "f.file_field :load_photo_file" in the view triggers Rails to invoke this method
  # This method only store the information
  # The file saving is done in before_save
  def load_photo_file=(data)
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

  def set_metadata
    # Store the date the image as taken
    image_datetime = @saved_image.get_exif_by_entry('DateTime')[0][1]
    self.taken_date = DateTime.strptime(image_datetime, '%Y:%m:%d %H:%M:%S') if image_datetime != nil
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
  
  # Add/remove existing tags to this photo's collection of tags
  def add_remove_tags(tags_attributes)
    tags_attributes.each do |index, tag|
      # Remove tags that were not selected/deselected
      self.photo_tags.where(tag_id: tag[:id].to_i).destroy_all if tag[:is_selected] == "0"
      
      # Add tags that are selected and had not been previously selected
      if tag[:is_selected] == "1" && !self.photo_tags.any? { |pt| pt.tag_id == tag[:id].to_i }
        self.photo_tags.build(tag_id: tag[:id].to_i)
      end
    end
  end
end