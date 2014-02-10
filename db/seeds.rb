# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def photo_data
  filename = 'DSC01740.JPG'
  @tmpfile = Tempfile.new(filename)
  File.open(@tmpfile.path, 'wb') do |dest_file|
    dest_file.write(IO.read(Rails.root.join('test', 'resources', 'images', filename)))
  end
  ActionDispatch::Http::UploadedFile.new({
                                             filename: 'DSC01740.JPG',
                                             type: 'image/jpg',
                                             tempfile: @tmpfile,
                                             head: "Content-Disposition: form-data; name=\"photo[load_photo_file]\"; filename=\"DSC01740.JPG\"\r\nContent-Type: image/jpeg\r\n"
                                         })
end

Fichier.delete_all
Photo.delete_all
Tag.delete_all
TagLink.delete_all
Comment.delete_all
Article.delete_all
ArticlePhoto.delete_all
User.delete_all
Country.delete_all
City.delete_all
Place.delete_all
Location.delete_all

# Create administrator account
admin = User.new(name: 'admin', password: 'default', password_confirmation: 'default')
admin.save!

# Create photos
start_datetime = DateTime.civil(2011, 12, 29, 0, 0, 0)
for i in 1..6
  puts "Creating photo #{i}"
  Photo.create! do |p|
    p.title = "Photo_#{i}"
    p.description = "This is photo #{i}"
    p.load_photo_file = photo_data
    p.taken_date = start_datetime.advance(minutes: i)
  end
  puts "Done photo #{i}"
end

# Create articles
article_one = Article.create! do |article|
  article.title = 'Adventure One'
  article.content = "<p>Tearaway is about blending the real and digital worlds, pulling down the boundaries that separate us from what we're playing. To that end, you're not just a gamer when you're playing Tearaway; you're a godlike presence, representing both the ultimate goal and the protagonist.</p><p>In essence, then, you play two roles. One of those roles is as a sentient envelope on a mission. Your first decision is to take the reins of either the male envelope Iota or the female envelope Atoi. (Note the playful spelling trick.) Iota or Atoi becomes the protagonist, the driving force behind the narrative and the personality that other characters interact with. No matter which one you choose, the end goal is the same. Reach the sun--that's all you have to do. The twist is that the sun is you. Yes, you, the player.</p><p>Through the magic of the PS Vita's front camera, your face appears within the outline of the sun and becomes the visual embodiment of the second of your two roles. You smile; sun smiles. You frown; sun frowns. You point your Vita at your dog; sun becomes a dog. An ugly visage (in your case, perhaps less ugly) intruding and bearing down on the papercraft environment causes a bit of an understandable stir, so Iota (or Atoi) sets out to find the meaning behind and origin of the thing from another world.</p>"
  article.published_at = DateTime.now
end
puts "Done articles"

# Add one photo to this article
ArticlePhoto.create! do |article_photo|
  article_photo.photo_id = Photo.first.id
  article_photo.article_id = article_one.id
end
puts "Done adding photos to articles"

# Create simple articles
puts "Create 10 more articles"
10.times do |j|
  Article.create! do |article|
    article.title = "Article #{j}"
    article.content = "<p>Tearaway is about blending the real and digital worlds, pulling down the boundaries that separate us from what we're playing. To that end, you're not just a gamer when you're playing Tearaway; you're a godlike presence, representing both the ultimate goal and the protagonist.</p><p>In essence, then, you play two roles. One of those roles is as a sentient envelope on a mission. Your first decision is to take the reins of either the male envelope Iota or the female envelope Atoi. (Note the playful spelling trick.) Iota or Atoi becomes the protagonist, the driving force behind the narrative and the personality that other characters interact with. No matter which one you choose, the end goal is the same. Reach the sun--that's all you have to do. The twist is that the sun is you. Yes, you, the player.</p><p>Through the magic of the PS Vita's front camera, your face appears within the outline of the sun and becomes the visual embodiment of the second of your two roles. You smile; sun smiles. You frown; sun frowns. You point your Vita at your dog; sun becomes a dog. An ugly visage (in your case, perhaps less ugly) intruding and bearing down on the papercraft environment causes a bit of an understandable stir, so Iota (or Atoi) sets out to find the meaning behind and origin of the thing from another world.</p>"
    article.published_at = DateTime.now
  end
end

# Create country for Ecuador
puts 'Creating country=Ecuador'
ecuador = Country.create! do |country|
  country.name = 'Ecuador'
  country.wikipedia_url = 'http://en.wikipedia.org/wiki/Ecuador'
end

# Creating location information for country=Ecuador
puts 'Creating location information for country=Ecuador'
Location.create! do |location|
  location.locationable = ecuador
  location.name = 'Ecuador'
  location.country = 'Ecuador'
  location.latitude = -2.8974913
  location.longitude = -79.0043379
  location.zoom_level = 4
end

# Create cities for Ecuador
puts 'Creating city=Cuenca'
cuenca = City.create! do |city|
  city.country = ecuador
  city.name = 'Cuenca'
  city.wikipedia_url = 'http://en.wikipedia.org/wiki/Cuenca,_Ecuador'
end

# Create location for Cuenca
puts 'Creating location information for city=Cuenca'
Location.create! do |location|
  location.locationable = cuenca
  location.name = 'Cuenca'
  location.city = 'Cuenca'
  location.country = 'Ecuador'
  location.latitude = -1.7929665
  location.longitude = -78.1368875
  location.zoom_level = 13
end

# Create places for Cuenca
puts 'Creating place=Tutto Freddo'
tutto_freddo = Place.create! do |place|
  place.city = cuenca
  place.place_type = PlaceType.find_by_name('Cafe')
  place.name = 'Tutto Freddo'
  place.description = 'This cafe, situated by the incredibly beautiful parque Abdón Calderón boasts two locations, one small, and one larger. Both offer a convivial environment with good, respectable, and quick service. The servers and waitresses bring you delicious coffee. I recommend both the cappuchino and the mochachino. Drink one while munching on a strawberry or blueberry tart, and do not forget to a leave a small tip because this place merits it. It goes without further ado that this place is recommended.'
  place.home_url = 'http://www.tuttofreddo.ec'
end

# Create locations for Tutto Freddo
puts 'Creating locations for place=Tutto Freddo'
puts "\tCreating first location"
Location.create! do |location|
  location.locationable = tutto_freddo
  location.name = 'Small Tutto Freddo'
  location.address = 'Parque Abdón Calderón'
  location.city = 'Cuenca'
  location.country = 'Ecuador'
  location.latitude = -2.8966129
  location.longitude = -79.0046871
  location.zoom_level = 18
end

puts "\tCreating second location"
Location.create! do |location|
  location.locationable = tutto_freddo
  location.name = 'Large Tutto Freddo'
  location.address = 'Parque Abdón Calderón'
  location.city = 'Cuenca'
  location.country = 'Ecuador'
  location.latitude = -2.8973512
  location.longitude = -79.0056416
  location.zoom_level = 18
end
