module PhotosHelper
  def photos_list(tags=nil)
    html = <<HTML 
      <div class="photos-list">
      	<% for photo in @photos %>
      	  <% photo_date = photo.taken_date.strftime("%b %-d at %-I:%-M") %>
      		<div class="photos-list-item" id="item_<%= photo.id %>">
      			<%= link_to image_tag(@home_url + photo.select_fichier('thumbnail').filename,
      				class: "photo-thumbnail"), photo_path(photo), class: "kaka" %>
      			<span class="photo-title"><%= strip_tags(photo.title) %></span>
      			<span class="photo-description"><%= strip_tags(photo.description) %></span>
      			<span class="photo-date"><%= strip_tags(photo_date) %></span>
      		</div>
      	<% end %>
      </div>
HTML
  end
  
  def print_me
    html = ""
    html = <<HTML
      <div>Hello I am a little tea pot short and stout</div>
HTML
  end
  
  def kakap
    content_tag(:div) do
      "kaka"
    end
    
    #concat content_tag(:p, "content2")
  end
  
  def photoslist(photos)
    content_tag("div", "photos-list") do
      i = 0
      photos.collect do |photo|
        i += 1
        photo_date = photo.taken_date.strftime("%b %-d at %-I:%-M")
        concat content_tag(:div, class: "photos-list-item") do
          concat content_tag(:span, "#{i} ")
        end
      end
    end
  end
end
