class Comment < ActiveRecord::Base
  #id: integer PKEY, NOT NULL
  #commentable_id: integer, FKEY, NOT NULL
  #commentable_type: string, NOT NULL
  #content: text, NOT NULL
  #user: string, NOT NULL
  #created_at: datetime
  #updated_at: datetime

  belongs_to :commentable, polymorphic: true

  validates_length_of :content, minimum: 1, allow_nil: false, allow_blank: false, message: "must be present"
  validates_length_of :user, minimum: 1, allow_nil: false, allow_blank: false, message: "must be present"

  before_validation :commentable_exists?

  def self.commentable_class(commentable_type)
    commentable_type.constantize
  end

  private

  def commentable_exists?
    begin
      commentable_class = self.commentable_type.constantize
    rescue
      errors.add(:base, "Could not find an appropriate class of #{self.commentable_type}")
      return false
    end

    if commentable_class.all.any? { |commentable| commentable.id == self.commentable_id }
      return true
    else
      errors.add(:base, "#{self.commentable_type} #{self.commentable_id} does not exist")
      return false
    end
  end
end
