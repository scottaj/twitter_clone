require 'bundler/setup'
require 'mongoid'


Mongoid.configure do |config|
  name = "rcr_app_testing"
  host = "localhost"
  config.master = Mongo::Connection.new.db(name)
end


require_relative '../../lib/tweet_model'
require_relative '../../lib/user_model'
require 'test/unit'

class TestTweetModel < Test::Unit::TestCase
  def setup()
    @tweet_model = TweetModel.new()
    @user_model = UserModel.new()
  end

  def teardown()
    Mongoid.purge!
  end

  def test_get_tweets_for_user()
    User.create(handle: "u1", following: [])
    User.create(handle: "bob")
    tweet_1 = @tweet_model.tweet("Trying out web development. #ruby #sinatra", "u1")
    sleep(3)
    tweet_2 = @tweet_model.tweet("Trying out web development. #ruby #sinatrates test #test TEST", "u1")
    sleep(2)
    tweet_3 = @tweet_model.tweet("Pokity poke poke", "u1")

    results = @tweet_model.get_tweets_for_user("u1")
    assert_equal([tweet_3, tweet_2, tweet_1], results, "Testing that a full set of user tweets are retrieved.")

    results = @tweet_model.get_tweets_for_user("u1", 2)
    assert_equal([tweet_3, tweet_2], results, "Testing that a partial set of user tweets are retireved.")
    results = @tweet_model.get_tweets_for_user("bob")
    assert_equal([], results, "Testing that a user with no tweets generates an empty list.")
  end

  def test_get_tweets_for_tag()
    User.create(handle: "u1", following: [])
    User.create(handle: "bob")
    tweet_1 = @tweet_model.tweet("Trying out web development. #ruby #test #sinatra", "u1")
    sleep(3)
    tweet_2 = @tweet_model.tweet("test test #test TEST", "u1")
    sleep(2)
    tweet_3 = @tweet_model.tweet("Pokity poke poke #ruby", "u1")
    results = @tweet_model.get_tweets_for_tag("ruby")
    assert_equal([tweet_3, tweet_1], results, "Testing that a full set of tweets for a hashtag are retrieved.")

    results = @tweet_model.get_tweets_for_tag("test", 1)
    assert_equal([tweet_2], results, "Testing that a limited set of tweets for a hashtag are retrieved.")

    results = @tweet_model.get_tweets_for_tag("derp")
    assert_equal([], results, "Testing that a non-existant hashtag returns an empty result set.")
  end

  def test_get_tweets_from_followers()
    User.create(handle: "u1", following: ["u2", "u3"])
    User.create(handle: "u2", following: [])
    User.create(handle: "u3", following: [])
    t1 = @tweet_model.tweet("Test #from u2", "u2")
    sleep(2)
    t2 = @tweet_model.tweet("test #from u3", "u3")
    sleep(3)
    t3 = @tweet_model.tweet("last test yo.", "u2")
    assert_equal([t3, t2, t1], @tweet_model.get_tweets_from_followers("u1"), "Testing retrieving tweets")
    assert_equal([t3], @tweet_model.get_tweets_from_followers("u1", 1), "Testing with a limit")
    assert_equal([], @tweet_model.get_tweets_from_followers("u3"), "Testing a user not following anyone.")
  end
end
