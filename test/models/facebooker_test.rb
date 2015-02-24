require 'test_helper'

class FacebookTest < ActionController::TestCase
  setup do
    facebook_cookies = Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
    binding.pry
    access_token = facebook_cookies["access_token"]
    graph = Koala::Facebook::API.new(access_token)

    @facebooker = Facebooker.new graph
  end

  test "posts message" do
    expected_message = "Hello this is a test message, foo; bar."

    response = @facebooker.post_message expected_message
    assert response.has_key?['id'] && !response['id'].blank?, 'message was not posted'
  end
end
