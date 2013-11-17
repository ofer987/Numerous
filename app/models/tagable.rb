module Tagable
  module ClassMethods
  end
  
  module InstanceMethods
    def tags_attributes      
    end
    
    def tags_attributes=(new_tags)
      new_tags ||= ""
      tag_names = new_tags.split(",")
    
      # Add tags
      tag_names.each do |name|
        name = name.strip.downcase
      
        # Create a new tag if it does not already exist
        tag = Tag[name] || Tag.create(name: name)
      
        # Add the tag to this photo's tag collection unless it already exists in it
        unless self.photo_tags.find_by_tag_id(tag.id)
          self.photo_tags.build { |photo_tag| photo_tag.tag_id = tag.id }
        end
      end
    end
    
    def photo_tags_attributes=(new_photo_tags)
      new_photo_tags.each do |index, photo_tag|
        # Remove tags that were not selected/deselected
        self.photo_tags.where(tag_id: photo_tag[:id].to_i).destroy_all if photo_tag[:is_selected] == "0"
      
        # Add tags that are selected and had not been previously selected
        if photo_tag[:is_selected] == "1" && !self.photo_tags.any? { |pt| pt.tag_id == photo_tag[:id].to_i }
          self.photo_tags.build(tag_id: photo_tag[:id].to_i)
        end
      end
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    
    receiver.class_eval do
    end
  end
end