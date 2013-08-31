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
  
  belongs_to :gazette
  
  before_validation :gazette_exists?
  
  def convert_content_to_html
    self[:content] = self[:content].to_html
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
