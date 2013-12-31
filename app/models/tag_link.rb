class TagLink < ActiveRecord::Base
  belongs_to :tag
  belongs_to :tagable, polymorphic: true

  def self.find_or_init(name)
  end

  def self.find_by_name(name)
    tag = Tag[name]
    self.where(tag_id: tag.id) unless tag.nil?
  end
end
