require 'bundler/setup'
require 'mongoid'

if __FILE__ == $0
  Mongoid.load!('mongoid.yml')
end

require_relative '../../lib/user_model'
require 'test/unit'

class TestUserModel < Test::Unit::TestCase
  def setup()
    @user_model = UserModel.new()
  end

  def teardown()
    Mongoid.purge!
  end

  def test_follow_user()
    User.create("u1", [])
    User.create("u2", [])
    assert_equal([], User.where(handle: "u1").first.following, "testing user not following anyone.")
    @user_model.follow_user("u1", "u2")
    assert_equal(["u2"], User.where(handle: "u1").first.following, "testing user following someone.")
  end

  # def test_unfollow_user()
    
  # end

  # def test_get_user_by_handle()
  #   @user_model.save_user(@user_2)
  #   reconstruction = @user_model.get_user_by_handle("jimBoB")
  #   assert_equal(@user_2.handle, reconstruction.handle, "Testing that handle reconstructs.")
  #   assert_equal(@user_2.following, reconstruction.following, "Testing that following array reconstructs.")
  # end

  # def test_user_exists?()
  #   @user_model.save_user(@user_1)
  #   assert_equal("test", @user_model.user_exists?("test"), "Testing that we find the exact user string.")
  #   assert_equal("test", @user_model.user_exists?("TeSt"), "Testing that we still find the user string if the case is mixed up.")
  #   assert_equal(nil, @user_model.user_exists?("Crazy"), "Testing that an utterly wrong username returns false.")
  #   assert_equal(nil, @user_model.user_exists?("retested"), "testing that a string with a username in it will not return true.")
  # end
end
