module Tagable
  module ClassMethods
    def equals?(lhs, rhs)
      name_equals?(lhs.name, rhs.name)
    end
    
    def name_equals?(lhs, rhs)
      lhs.strip.downcase == rhs.strip.downcase
    end
    
    def [](name)
      self.where(["lower(name) = ?", name.to_s.strip.downcase]).first
    end
    
    def find_by_name(name)
      self.where(["lower(name) = ?", name.to_s.strip.downcase]).first
    end
  end
  
  module InstanceMethods
    #def ==(other)
    #  return false if other == nil
    #  return self.name.strip.downcase == other.name.strip.downcase
    #end
    
    #def <=>(other)
    #  return false if other == nil
    #  return self.name.strip.downcase <=> other.name.strip.downcase
    #end
    
    def to_s
      name
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end