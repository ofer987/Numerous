require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user_params = {
      name: "Shawn Mclean",
      username: "shawn123",
      password: "password",
      password_confirmation: "password"
    }
  end

  test "user should have username" do
    assert_model User, @user_params, :username
  end

  test "user should have name" do
    assert_model User, @user_params, :name
  end

  test "username should be unique" do
    existing_user = users(:dan)
    new_user = User.new @user_params.merge(username: existing_user[:username])

    refute new_user.valid?, "New user cannot have duplicate username #{new_user.username}: " +
      new_user.errors.full_messages.to_s
  end

  def assert_model klass, params, property
    valid_model = klass.new params
    assert valid_model.valid?, "#{klass.to_s} is not valid: #{valid_model.errors.full_messages}"

    invalid_model = klass.new params.reject { |key, value| key == property.to_sym }
    refute invalid_model.valid?, "#{property.to_s} should be included: #{invalid_model.errors.full_messages}"
  end
end
