class Article < ActiveRecord::Base
  # id: integer, PKEY, NOT NULL
  # gazette_id: integer, PKEY, FKEY, NOT NULL
  # title: string, NOT NULL, Default ''
  # sub_title: string
  # content: text, NOT NULL, Default ''
  # published_at: datetime, NOT NULL, Default: now
  # updated_at: datetime
  # created_at: datetime

  has_many :article_photos, dependent: :delete_all
  has_many :photos, through: :article_photos
  
  has_many :comments, as: :commentable, dependent: :destroy
  
  has_many :tag_links, as: :tagable, dependent: :destroy
  has_many :tags, through: :tag_links
  include Tagable 

  after_initialize :set_published_at_to_now

  validates_presence_of :title, allow_blank: true
  validates_presence_of :content, allow_blank: true
  validates_presence_of :published_at

  self.per_page = 5
  
  default_scope { order('published_at DESC') }

  def content
    RedCloth.new(self[:content]).to_html
  end

  def photos_attributes=(attributes)
    attributes[:load_photo_files].each do |uploaded_file|
      self.photos.build(title: '', load_photo_file: uploaded_file)
    end
  end
  
  def article_photos_attributes=(attributes)
    if attributes != nil
      add_remove_photos(attributes)
    end
  end
  
  private

  def to_html(content)
    # It is assumed that the entry is written 
    # in paragraph form (at least one p
    html = "<p>#{content.strip}</p>"
      
    # replace every newline (and/or carriage return) with a </p<p>
    html = html.gsub(/(\r{0,1}\n{1})+/, "</p><p>")
  end
  
  def add_remove_photos(photos_attributes)
    photos_attributes.each do |index, photo|
      self.article_photos.where(photo_id: photo[:id].to_i).destroy_all if photo[:is_selected] == "0"
      
      if photo[:is_selected] == "1" && !self.article_photos.where(photo_id: photo[:id].to_i).any?
        self.article_photos.build(photo_id: photo[:id].to_i)
      end
    end
  end
  
  def set_published_at_to_now
    self.published_at ||= DateTime.now.getutc if self.new_record?
  end
end
