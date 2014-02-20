require 'test_helper'

class WebsiteTest < ActiveSupport::TestCase
  test 'url should not be nil' do
    website = places(:freddo).websites.build(url: nil)
    refute website.valid?, 'nil url should not be valid'
  end

  test 'url should not be blank' do
    website = places(:freddo).websites.build(url: '')
    refute website.valid?, 'blank url should not be valid'
  end

  test 'website should belong to a place' do
    website = Website.new(url: 'www.facebook.com/somewhere', 
                          url_type: 'home')
    refute website.valid?, 'website does not belong to a place'
  end
end
