module Selectable
  module ClassMethods
    def find_selected_ids(params)
      values = []
      
      params.each do |key, value|
        if /^#{self.to_s.downcase}_\d+/.match(key)
          values << value
        end
      end
      
      values
    end
  end
  
  module InstanceMethods
    def to_name_id
      "#{self.class.to_s.downcase}_#{self.id}"
    end
    
    def to_id
      self.id
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end