#load project environment
task fix_dates: :environment do
  for photo_id in 51..72
    photo = Photo.where(id: photo_id).first
  	datetime = Magick::ImageList.new("public/images/photos/" + photo.small_fichier.filename).get_exif_by_entry("DateTimeOriginal")[0][1]
    photo.taken_date = DateTime.strptime(datetime, '%Y:%m:%d %H:%M:%S')
    photo.save!
  end
end
	