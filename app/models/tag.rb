class Tag < ActiveRecord::Base
  #id: integer, PKEY, NOT NULL
  #name: string, NOT NULL, default: ""
  #created_at: datetime
  #updated_at: datetime
  
  include Tagable
  
  has_many :photo_tags, dependent: :delete_all
  has_many :photos, through: :photo_tags
  
  validates_presence_of :name, on: :create, message: "can't be blank"
  validates_uniqueness_of :name, on: :create, message: "must be unique", case_sensitive: false
  
  def self.equals?(lhs, rhs)
    name_equals?(lhs.name, rhs.name)
  end
  
  def self.[](name)
    self.where(["lower(name) = ?", name.to_s.strip.downcase]).first
  end
  
  def self.find_by_name(name)
    self.where(["lower(name) = ?", name.to_s.strip.downcase]).first
  end
  
  def to_s
    self.name
  end
  
  private
  
  def self.name_equals?(lhs, rhs)
    lhs.strip.downcase == rhs.strip.downcase
  end
end
