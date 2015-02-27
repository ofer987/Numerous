include ActionView::Helpers::AssetTagHelper
include ActionView::Helpers::UrlHelper

class MyMarkdown
  attr_reader :raw_content

  def initialize(raw_content, replacement_values = nil)
    @raw_content = raw_content
    @replacement_values = replacement_values

    markdown_renderer = Redcarpet::Render::HTML.new
    @markdown = Redcarpet::Markdown.new(markdown_renderer)
  end

  def content
    marked_content = @markdown.render(@raw_content)

    replace_tokens(marked_content)
  end

  private

  def replace_tokens(content)
    content.gsub(/(\[[^\[\]]*\])/) { |token| replace_photo_tokens(token[1..-2]) }
  end

  def replace_photo_tokens(title)
    return '' if @replacement_values.nil?

    article = @replacement_values[:article]
    return '' if article.nil?

    photo = Photo.find_by_title(title)
    return '' if photo.nil?

    <<-HTML
      <span class="thumbnail">
        #{image_tag(Photo.local_photos_dir + photo.thumbnail_fichier.filename, class: "photo-thumbnail")}
      </span>
    HTML
  end
end
