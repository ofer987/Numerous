class User < ActiveRecord::Base
  #id: integer, PKEY, NOT NULL
  #name: varchar(255), NOT NULL
  #password_digest: varchar(255), NOT NULL
  #created_at: datetime
  #updated_at: datetime

  has_many :articles

  validates :name, presence: true, uniqueness: true
  after_destroy :ensure_an_admin_remains

  has_secure_password

  def oauth_token
    'CAACEdEose0cBAFxyOTO0cUoMYBxgXAUn0fKFKsp5wGhiUbrAHvdUjUafHmf7AZCIjnbng7ATg7hsFNDZCKs6NzEVJiLhOiBuTAJsQYdUIsHXOUxm6FAyNchwP5bAJKx4OomfNB73tFLrFKrudHz86lFl1Y6iZBCTy3R3BOxMKZAaIqkroZCDd3N28aZBSFFIOSnmbKVhtZAgm90vX4Yqt2I'
  end

  private

  def ensure_an_admin_remains
    if User.count.zero?
      raise 'Cannot delete the last user'
    end
  end
end
