module Tagable
  module ClassMethods
  end
  
  module InstanceMethods
    
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    
    receiver.class_eval do
    end
  end
end