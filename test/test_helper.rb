ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :filesize_types, :photos, :fichiers, :comments, :users, :tags, :photo_tags, :gazettes, :articles, :article_photos

  # Add more helper methods to be used by all tests here...
  def login_as(user)
    session[:user_id] = users(user).id
  end
  
  def logout
    session.delete :user_id
  end
  
  def setup
    login_as(:admin) if defined? session and !@manual_login
  end 
  
  def photos_test_dir
    "test/photos/"
  end
  
  def photos_dir
    "app/assets/images/photos/"
  end
end
