class Article < ActiveRecord::Base
  # id: integer, PKEY, NOT NULL
  # gazette_id: integer, PKEY, FKEY, NOT NULL
  # title: string, NOT NULL, Default ''
  # sub_title: string
  # content: text, NOT NULL, Default ''
  # updated_at: datetime
  # created_at: datetime

  attr_accessible :gazette_id, :title, :sub_title, :content, :created_at
  
  has_many :article_photos, dependent: :delete_all
  has_many :photos, through: :article_photos
  
  belongs_to :gazette
  
  before_validation :gazette_exists?, :content_does_not_contain_whitespace
  
  def content=(value)
    # It is assumed that the entry is written in paragraph form (at least one paragraph)
    value = "<p>#{value}</p>"
    
    # replace every newline (and/or carriage return) with a </p<p>
    value.gsub!(/(\r{0,1}\n{1})+/, "</p><p>")
    
    self[:content] = value
  end
  
  private
  
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
