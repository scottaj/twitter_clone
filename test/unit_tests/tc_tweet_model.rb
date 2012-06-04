require_relative '../../lib/tweet_model'
require_relative '../../lib/user_model'
require_relative '../../lib/user'
require 'test/unit'

class TestTweetModel < Test::Unit::TestCase
  def setup()
    @user = User.new("test")
    @following_1 = User.new("Deedle")
    @following_2 = User.new("Dum")
    text_1 = "Got super #drunk last night! #partyrocker #brolife"
    @tweet_1 = Tweet.new(text_1, @user)
    connection = Mongo::Connection.new.db("testdb")
    collection = "testCollTw"
    @user_model = UserModel.new(connection, "test")
    @tweet_model = TweetModel.new(connection, collection)
    @db_conn = connection.collection(collection)
  end

  def teardown()
    @db_conn.remove()
  end

  def test_save_tweet()
    id = @tweet_model.save_tweet(@tweet_1)
    saved = @db_conn.find_one("_id" => id)
    
    assert_equal(@tweet_1.text, saved["text"], "Testing that text was saved correctly.")
    assert_equal(@tweet_1.user, saved["user"], "Testing that user handle was saved correctly.")
    assert_equal(@tweet_1.timestamp.to_i, saved["timestamp"], "Testing that timestamp was saved correctly.")
    assert_equal(@tweet_1.tags, Set.new(saved["tags"]), "Testing that tags were saved correctly.")
  end

  def test_get_tweets_for_user()
    tweet_1 = @user.tweet("Trying out web development. #ruby #sinatra", @tweet_model)
    sleep(3)
    tweet_2 = @user.tweet("#mongo seems like a cool database.", @tweet_model)
    sleep(2)
    tweet_3 = @user.tweet("Wazzzzzzup!", @tweet_model)

    results = @tweet_model.get_tweets_for_user(@user)
    assert_equal([tweet_3, tweet_2, tweet_1], results, "Testing that a full set of user tweets are retrieved.")

    results = @tweet_model.get_tweets_for_user(@user, 2)
    assert_equal([tweet_3, tweet_2], results, "Testing that a partial set of user tweets are retireved.")

    newUser = User.new("otherGuy")
    results = @tweet_model.get_tweets_for_user(newUser)
    assert_equal([], results, "Testing that a user with no tweets generates an empty list.")
  end

  def test_get_tweets_for_tag()
    tweet_1 = @user.tweet("Hello, world! #hashtag", @tweet_model)
    sleep(4)
    tweet_2 = @user.tweet("Another interesting tweet. #twitter", @tweet_model)
    sleep(1)
    tweet_3 = @user.tweet("One more for the road. #hashtag #twitter", @tweet_model)

    results = @tweet_model.get_tweets_for_tag("hashtag")
    assert_equal([tweet_3, tweet_1], results, "Testing that a full set of tweets for a hashtag are retrieved.")

    results = @tweet_model.get_tweets_for_tag("twitter", 1)
    assert_equal([tweet_3], results, "Testing that a limited set of tweets for a hashtag are retrieved.")

    results = @tweet_model.get_tweets_for_tag("derp")
    assert_equal([], results, "Testing that a non-existant hashtag returns an empty result set.")
  end

  def test_get_tweets_from_followers()
    @user.follow_user(@following_1)
    @user.follow_user(@following_2)
    t1 = @following_1.tweet("Derp", @tweet_model)
    sleep(2)
    t2 = @following_2.tweet("Derpity derp", @tweet_model)
    sleep(3)
    t3 = @following_1.tweet("Dumbity derp derp", @tweet_model)
    assert_equal([t1, t2, t3], @tweet_model.get_tweets_from_followers(@user), "Testing retrieving tweets")
    assert_equal([t1], @tweet_model.get_tweets_from_followers(@user, 1), "Testing with a limit")
    assert_equal([], @tweet_model.get_tweets_from_followers(@following_1), "Testing a user not following anyone.")
  end
end
