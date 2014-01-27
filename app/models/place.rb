class Place < ActiveRecord::Base
  belongs_to :city
  belongs_to :place_type

  has_many :locations, as: :locationable, dependent: :destroy
end
