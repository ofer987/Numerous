class MyMarkdown
  attr_reader :raw_content

  def initialize(raw_content)
    @raw_content = raw_content

    markdown_renderer = Redcarpet::Render::HTML.new
    @markdown = Redcarpet::Markdown.new(markdown_renderer)
  end

  def content
    @markdown.render(processed_content)
  end

  private

  def processed_content
    raw_content.gsub(/(\[[^\[\]]*\])/) { |place_holder| replace_photo(place_holder[1..-2]) }
  end

  def replace_photo(title)
    photo = Photo.find_by_title(title)

    return '' if photo.nil?

    <<-HTML
      <div id="item_<%= photo.id %>">
        <div class="thumbnail">
          <%= link_to image_tag(#{Photo.local_photos_dir + photo.thumbnail_fichier.filename}, class: "photo-thumbnail"), photo_path(photo, tags: params[:tags]) %>
        </div>
      </div>
    HTML
  end
end
