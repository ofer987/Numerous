class Gazette < ActiveRecord::Base
  # id: integer, PKEY, NOT NULL
  # name: string, NOT NULL, Default ''
  # description: text, NOT NULL, Default ''
  # created_at: datetime
  # updated_at: datetime

  attr_accessible :name, :description
  
  has_many :articles, dependent: :destroy
  
  def find_by_param_sym(param_sym)
    /^gazette_(\.*)$/ =~ param_sym
    gazette_name = $1
    
    Gazette.find_by_name(gazette_name)
  end
  
  def to_param_sym
    "gazette_#{self.name}".to_sym
  end
end
