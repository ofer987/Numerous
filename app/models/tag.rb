class Tag < ActiveRecord::Base
  #id: integer, PKEY, NOT NULL
  #name: string, NOT NULL, default: ""
  #created_at: datetime
  #updated_at: datetime
  
  default_scope { order('name ASC') }

  scope :all_tagable, ->(tagable_class) do 
    self.joins(:tag_links).
      where(tag_links: { tagable_type: tagable_class.to_s } ).distinct
  end
  
  has_many :tag_links, dependent: :destroy
  
  validates_presence_of :name, message: "can't be blank"
  validates_uniqueness_of :name, message: "must be unique", 
    case_sensitive: false
  
  def self.equals?(lhs, rhs)
    name_equals?(lhs.name, rhs.name)
  end
  
  def self.[](name)
    self.find_by_name(name)
  end

  def self.find_or_init_by_name(name)
    self.find_by_name(name) || self.new(name: name)
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
