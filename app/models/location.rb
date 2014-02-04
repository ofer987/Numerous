class Location < ActiveRecord::Base
  # id: integer, NOT NULL, index
  # locationable_id: integer, NOT NULL, index
  # locationable_type: nvarchar(255), NOT NULL, index
  # name: nvarchar(255)
  # address: nvarchar(255)
  # city: nvarchar(255)
  # province: nvarchar(255)
  # country: nvarchar(255)
  # postal_code: nvarchar(255)
  # coordinates: nvarchar(255)
  # created_at: datetime
  # updated_at: datetime
  
  belongs_to :locationable, polymorphic: true

  def full_address
    "#{address}\n" +
      "#{city}, #{province}\n" +
      "#{postal_code}\n" +
      "#{country}"
  end
end
