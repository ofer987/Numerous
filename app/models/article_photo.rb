class ArticlePhoto < ActiveRecord::Base
  # id: integer, PKEY, NOT NULL
  # article_id: integer, PKEY, FKEY, NOT NULL
  # updated_at: datetime
  # created_at: datetime
  
  belongs_to :article
  belongs_to :photo
  
  #before_validation :article_exists?, :photo_exists?
  
  private
  
  def article_exists?
    if Article.all.any? { |article| article.id == self.article_id }
      true
    else
      errors.add(:base, "Article #{self.article_id} does not exist")
      false
    end
  end
  
  def photo_exists?
    if Photo.all.any? { |photo| photo.id == self.photo_id }
      true
    else
      errors.add(:base, "Photo #{self.photo_id} does not exist")
      false
    end
  end
end
