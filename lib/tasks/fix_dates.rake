# load project environment
task fix_dates: :environment do |t, args|
  puts "Environment: #{Rails.env}"
  Photo.all.each do |photo|
    puts "Photo.id = #{photo.id}"
    puts "\tfilename = #{photo.filename}"
    puts "\ttaken_date = #{photo.taken_date}\n"
  
    begin
      datetime = Magick::ImageList.new(Rails.root.join('public', 'images', 'photos', photo.filename)).get_exif_by_entry("DateTimeOriginal")[0][1]      
    rescue Exception => e
      puts "Error: #{e.message}"
      puts "Backtrace: #{e.backtrace}"
    end
    
    unless datetime.nil?      
      photo.taken_date = DateTime.strptime(datetime, '%Y:%m:%d %H:%M:%S')
      puts "Failed to save the photo: #{photo.errors.full_messages}" unless photo.save
    end    
  end
end
	