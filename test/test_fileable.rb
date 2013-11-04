IMAGE_SOURCE_FOLDER = Rails.root.join('test', 'resources', 'images')
IMAGE_DEST_FOLDER = Rails.root.join('test', 'assets', 'images', 'photos')

# For testing purposes
# The test photos should not be mixed in the real assets folder  
class Photo
  def photo_store
    IMAGE_DEST_FOLDER
  end
end

module TestFileable
  module ClassMethods
    
  end
  
  module InstanceMethods
    def setup_photo_files
      # Recreate the destination subdir
      FileUtils.mkdir_p(IMAGE_DEST_FOLDER)    
    end
    
    def teardown_photo_files
      # Remove the destination subdir
      FileUtils.rm_rf(IMAGE_DEST_FOLDER)

      # Recreate the destination  subdir
      FileUtils.mkdir_p(IMAGE_DEST_FOLDER)
    
      # Delete the temporary file
      @tmpfile.unlink unless @tmpfile == nil
    end
    
    def photo_data
      filename = 'DSC01740.JPG'
      @tmpfile = Tempfile.new(filename)
      File.open(@tmpfile.path, 'wb') do |dest_file|
        dest_file.write(IO.read(IMAGE_SOURCE_FOLDER.join(filename)))
      end
      ActionDispatch::Http::UploadedFile.new({
                                                 filename: 'DSC01740.JPG',
                                                 type: 'image/jpg',
                                                 tempfile: @tmpfile,
                                                 head: "Content-Disposition: form-data; name=\"photo[load_photo_file]\"; filename=\"DSC01740.JPG\"\r\nContent-Type: image/jpeg\r\n"
                                             })
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end