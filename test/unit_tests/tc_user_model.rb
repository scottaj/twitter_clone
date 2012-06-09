require 'bundler/setup'
require 'mongoid'

Mongoid.configure do |config|
  name = "rcr_app_testing"
  host = "localhost"
  config.master = Mongo::Connection.new.db(name)
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
    User.create(handle: "u1", following: [])
    User.create(handle: "u2", following: [])
    User.create(handle: "u3", following: [])
    assert_equal([], User.where(handle: "u1").first.following, "testing user not following anyone.")
    @user_model.follow_user("u1", "u2")
    assert_equal(["u2"], User.where(handle: "u1").first.following, "testing user following someone.")
    @user_model.follow_user("u1", "u3")
    assert_equal(["u2", "u3"], User.where(handle: "u1").first.following, "testing user following a couple people.")
  end

  def test_unfollow_user()
    User.create(handle: "u1", following: ["u2", "u3"])
    User.create(handle: "u2", following: [])
    User.create(handle: "u3", following: [])
    assert_equal(["u2", "u3"], User.where(handle: "u1").first.following, "testing user starts with followers.")
    @user_model.unfollow_user("u1", "u2")
    assert_equal(["u3"], User.where(handle: "u1").first.following, "testing removing a follower.")
    @user_model.unfollow_user("u1", "u2")
    assert_equal(["u3"], User.where(handle: "u1").first.following, "testing removing a non-existant follower.")
    @user_model.unfollow_user("u1", "u3")
    assert_equal([], User.where(handle: "u1").first.following, "testing removing all followers.")
  end

  def test_following()
    User.create(handle: "u1", following: ["u2", "u3"])
    User.create(handle: "u2", following: [])
    User.create(handle: "u3", following: [])
    assert(@user_model.following?("u1", "u2"), "Testing a user that is being followed.")
    assert_equal(false, @user_model.following?("u1", "u4"), "Testing a user that is not being followed")
  end

  def test_get_user_by_handle()
    User.create(handle: "u1", following: [])
    reconstruction = @user_model.get_user_by_handle("u1")
    assert_equal("u1", reconstruction.handle, "Testing that handle reconstructs.")
    assert_equal([], reconstruction.following, "Testing that following array reconstructs.")
  end

  def test_user_exists?()
    User.create(handle: "test", following: [])
    assert_equal("test", @user_model.user_exists?("test"), "Testing that we find the exact user string.")
    assert_equal("test", @user_model.user_exists?("TeSt"), "Testing that we still find the user string if the case is mixed up.")
    assert_equal(nil, @user_model.user_exists?("Crazy"), "Testing that an utterly wrong username returns false.")
    assert_equal(nil, @user_model.user_exists?("retested"), "testing that a string with a username in it will not return true.")
  end

  def test_user_search()
    User.create(handle: "test", following: [])
    User.create(handle: "u1", following: [])
    User.create(handle: "u2", following: [])
    User.create(handle: "user", following: [])
    User.create(handle: "testy", following: [])
    assert_equal([], @user_model.user_search("zi"))
    assert_equal(["u1", "u2", "user"], @user_model.user_search("u"))
    assert_equal(["user"], @user_model.user_search("us"))
    assert_equal(["test", "testy"], @user_model.user_search("es"))
  end
end
