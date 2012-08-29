require 'test_helper'

class FichierTest < ActiveSupport::TestCase
  test "Fichier should belong to a photo" do
    photoless_fichier = Fichier.new
    photoless_fichier.photo_id = rand(12345567) # Probably this id will not exist
    photoless_fichier.filesize_type = FilesizeType["Original"]
    
    assert photoless_fichier.invalid?, 'fichier should belong to a photo'
  end
  
  test "Fichier should have a valid type" do
    typeless_fichier = photos(:eaton_college).fichiers.new(filesize_type_id: rand(12345667))
    
    assert typeless_fichier.invalid?, 'fichier should have a valid type of FilesizeType'
  end
end
