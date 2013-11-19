# load project environment
task fix_dates: :environment do |t, args|
  Photo.all.each do |photo|
    datetime = Magick::ImageList.new(Rails.root.join('public', 'images', 'photos', photo.small_fichier.filename)).get_exif_by_entry("DateTimeOriginal")[0][1]
    unless datetime.nil?
      photo.taken_date = DateTime.strptime(datetime, '%Y:%m:%d %H:%M:%S')
      photo.save!
    end
  end
end
	