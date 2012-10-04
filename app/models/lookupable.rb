module Lookupable
  module ClassMethods
    def [](name)
      self.where(["lower(name) = ?", name.to_s.strip.downcase]).first  
    end
    
    def find_by_name(name)
      self.where(["lower(name) = ?", name.to_s.strip.downcase]).first
    end
  end
  
  module InstanceMethods 
    def to_s
      name
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    
    receiver.class_eval do
      validates_presence_of :name, on: :create, :message => "can't be blank"
      validates_uniqueness_of :name, on: :create, message: "must be unique", case_sensitive: false      
    end
  end
end