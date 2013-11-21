class User < ActiveRecord::Base
  #id: integer, PKEY, NOT NULL
  #name: varchar(255), NOT NULL
  #password_digest: varchar(255), NOT NULL
  #created_at: datetime
  #updated_at: datetime

  validates :name, presence: true, uniqueness: true
  after_destroy :ensure_an_admin_remains
  
  has_secure_password
  
  private
  
  def ensure_an_admin_remains
    if User.count.zero?
      raise 'Cannot delete the last user'
    end
  end
end
