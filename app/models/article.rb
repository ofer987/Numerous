class Article < ActiveRecord::Base
  # id: integer, PKEY, NOT NULL
  # gazette_id: integer, PKEY, FKEY, NOT NULL
  # title: string, NOT NULL, Default ''
  # sub_title: string
  # content: text, NOT NULL, Default ''
  # updated_at: datetime
  # created_at: datetime

  attr_accessible :gazette_id, :title, :sub_title, :content, :created_at, :photos
  
  has_many :article_photos, dependent: :delete_all
  has_many :photos, through: :article_photos
  
  has_many :comments, as: :commentable, dependent: :destroy
  
  belongs_to :gazette
  
  before_validation :gazette_exists?
  
  attr_accessor :is_convert_to_html
  
  def content=(value)
    if @is_convert_to_html
      value = value.to_html
    end
    
    self[:content] = value
  end
  
  def photos_attributes=(attributes)
    if attributes != nil
      add_remove_photos(attributes)
    end
  end
  
  private
  
  def add_remove_photos(photos_attributes)
    photos_attributes.each do |index, photo|
      self.article_photos.where(photo_id: photo[:id].to_i).destroy_all if photo[:is_selected] == "0"
      
      if photo[:is_selected] == "1" && !self.article_photos.where(photo_id: photo[:id].to_i).any?
        self.article_photos.build(photo_id: photo[:id].to_i)
      end
    end
  end
  
  def content_does_not_contain_whitespace
    if (self.content =~ /\r/) != nil
      errors.add(:base, "Content should not contain a carriage return")
      return false
    end
    
    if (self.content =~ /\n/) != nil
      errors.add(:base, "Content should not contain a newline")
      return false
    end
    
    return true;
  end
  
  def gazette_exists?
    if Gazette.all.any? { |gazette| gazette.id == self.gazette_id }
      true
    else
      errors.add(:base, "Gazette #{self.gazette_id} does not exist")
      false
    end
  end
end
