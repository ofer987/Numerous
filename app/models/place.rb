class Place < ActiveRecord::Base
  belongs_to :city
  belongs_to :place_type
end
