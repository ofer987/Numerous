class Article < ActiveRecord::Base
  # id: integer, PKEY, NOT NULL
  # gazette_id: integer, PKEY, FKEY, NOT NULL
  # title: string, NOT NULL, Default ''
  # sub_title: string
  # content: text, NOT NULL, Default ''
  # updated_at: datetime
  # created_at: datetime

  attr_accessible :gazette_id, :title, :sub_title, :content
  
  belongs_to :gazette
  
  def content=(value)
    # It is assumed that the entry is written in paragraph form (at least one paragraph)
    value = "<p>#{value}</p>"
    
    # replace every newline (and/or carriage return) with a </p<p>
    value.gsub!(/(\r{0,1}\n{1})+/, "</p><p>")
    
    self[:content] = value
  end
end
