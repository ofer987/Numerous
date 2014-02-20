class Website < ActiveRecord::Base
  # id: integer, primary key, not nil,
  # place_id: integer, foreign key, not nil
  # url: string, not nil
  # url_type: string

  belongs_to :place

  validates :url, presence: { allow_blank: false, allow_nil: false }
  validates :place_id, presence: { allow_blank: false, allow_nil: false }
end
