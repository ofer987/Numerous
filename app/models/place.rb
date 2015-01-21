class Place < ActiveRecord::Base
  belongs_to :city
  belongs_to :place_type

  has_many :locations, as: :locationable, dependent: :destroy
  has_many :websites, dependent: :destroy
  has_many :contacts, dependent: :destroy

  def description
    markdown_renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(markdown_renderer)

    markdown.render(self[:description] || '')
  end
end
