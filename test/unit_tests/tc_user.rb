require 'test/unit'
require_relative '../../lib/user.rb'

class TestUser < Test::Unit::TestCase
  def setup()
    @user = User.new("test")
    @other_user = User.new("thatGuy")
    @one_more_user = User.new("oneMore")
  end

  def test_follow_user()
    @user.follow_user(@other_user)
    assert_equal(Set.new(["thatGuy"]), @user.following, "Could not add 1 user.")
    @user.follow_user(@one_more_user)
    assert_equal(Set.new(["thatGuy", "oneMore"]), @user.following, "Could not add more than 1 user.")
  end

  def test_unfollow_user()
    @user.follow_user(@other_user)
    @user.follow_user(@one_more_user)
    @user.unfollow_user(@other_user)
    assert_equal(Set.new(["oneMore"]), @user.following, "Did not remove user properly.")
    @user.unfollow_user(@one_more_user)
    assert_equal(Set.new(), @user.following, "Did not remove last user properly.")
    @user.unfollow_user(@other_user)
    assert_equal(Set.new(), @user.following, "Did not handle removing a user who wasen't being followed properly.")
  end

  def test_tweet()
    tweet = @user.tweet("Making my own twitter backend. #coding #ruby")
    assert_equal("Making my own twitter backend. #coding #ruby", tweet.text, "Testing tweet text.")
    assert_equal("test", tweet.user, "Testing tweet user handle.")
    assert_equal(Set.new(["coding", "ruby"]), tweet.tags, "Testing tweet tags.")
    assert_equal(Time.now.wday, tweet.timestamp.wday, "Testing tweet timestamp.")
  end

  def test_serialize()
    assert_equal({:doctype => :user, :document => {:_id => @user.handle, :following => @user.following}}, @user.serialize, "Testing serialization of user.")
  end
end
