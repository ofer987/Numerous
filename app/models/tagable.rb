module Tagable
  module ClassMethods
  end
  
  module InstanceMethods
    def tags_attributes      
    end
    
    def tags_attributes=(attributes)
      tags = attributes[:tags_attributes]
      unless tags.nil?
        # Add tags
        tags.split(',').each do |name|
          self.tags << Tag.find_or_init_by_name(name.strip.downcase)
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
