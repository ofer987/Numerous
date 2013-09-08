class Photo < ActiveRecord::Base
  #id: integer, PKEY, NOT NULL
  #title: varchar(255), NOT NULL
  #description: text, NOT NULL
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
    
  validates_length_of :title, minimum: 1, allow_nil: false, allow_blank: false, :message => "must be present"
  validates_presence_of :filename, on: :create, :message => "must be specified"
  validates_presence_of :taken_date, on: :create, :message => "must have a date, at least a default one"
  validates_format_of :filename, :with => /\.(jpg|png)\z/i, :message => "is invalid"
  
  validate :validate_has_unique_fichiers
  
  #validates_format_of :taken_date, :with => /^\d\d\d\d-\d\d-\d\d\s\d\d:\d\d:\d\d$/, :on => :create, 
  #  :message => "is invalid, needs to be in date format YYYY-MM-DD HH:MM:SS"
 
  # Root directory of the photo public/photos
  PHOTO_STORE = Rails.root.join('app', 'assets', 'images', 'photos')
  
  # Invoke save_photo method when save is completed
  before_save :before_save
  after_save  :after_save

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
      filename = 'random.jpg'
    end
    
    # Store the data for later use
    set_filename(filename)
    @photo_data = data
  end
  
  def before_save   
    if @photo_data
      # Write the data out to a file
      full_filename = File.join(PHOTO_STORE, self.filename)      
      
      File.open(full_filename, 'wb') do |f|
        f.write(@photo_data.read)
      end
            
      # Load the image
      @saved_image = Magick::ImageList.new(full_filename) 
    
      # Store the date the image as taken
      image_datetime = @saved_image.get_exif_by_entry('DateTime')[0][1]
      if (image_datetime == nil)
        image_datetime = @saved_image.get_exif_by_entry('DateTimeOriginal')[0][1]
      end
      if (image_datetime != nil)
        self.taken_date = DateTime.strptime(image_datetime, '%Y:%m:%d %H:%M:%S')
      end
    end
  end
  
  def after_save
    if @photo_data
      # Create the files
      create_and_resize_fichiers
            
      @photo_data = nil
    end
  end
  
  def set_filename(new_filename)
    /^([^\.]+)\.(jpg|png)/i =~ new_filename
    new_filename_simple = $1
    new_filename_extension = $2
    
    # If another photo already uses the same file,
    # then add a number to the end of the filename untill unique
    i = 0
    while true
      existing_full_filename = File.join(PHOTO_STORE, new_filename)
            
      if File.exists?(existing_full_filename)
        i=i+1
        new_filename = new_filename_simple + "_" + i.to_s + "." + new_filename_extension 
      else
        break
      end
    end
    
    self.filename = new_filename
  end
 
  private
  
  def create_and_resize_fichiers
    for filesize_type in FilesizeType.all do
      if (filesize_type.name == 'original')
        # Just create a fichier record in the db
        # no need to save the file to hdd because the original file has
        # already been saved
        fichier = self.fichiers.create(filesize_type: filesize_type)
      elsif (filesize_type.name == 'small' or
        filesize_type.width < @saved_image.columns or
        filesize_type.height < @saved_image.rows) then
        # Always create a small version of this photo, 
        # and other sizes if possible
        fichier = self.fichiers.create(filesize_type: filesize_type)
        resized_image = @saved_image.resize_to_fit(filesize_type.width, filesize_type.height)
      
        # get the filename
        resized_image_filename = File.join(PHOTO_STORE, fichier.filename)
        
        # write the file
        resized_image.write(resized_image_filename)
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