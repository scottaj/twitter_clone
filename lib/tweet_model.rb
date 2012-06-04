require 'bundler/setup'
require_relative 'tweet'
require 'mongo'

# Model class for saving and loading tweets to a mongo database.
class TweetModel

  ##
  # Creates a new TweetModel object.
  #
  # ===ARGS:
  # - connection should be a Mongo database connection.
  # - collection_name should be the name of a collection within the database.
  def initialize(connection, collection_name)
    @connection = connection.collection(collection_name)
  end

  ##
  # Saves a Tweet object to the database.
  #
  # ===ARGS:
  # - tweet should be a tweet object to be saved.
  def save_tweet(tweet)
    @connection.insert("text" => tweet.text, "user" => tweet.user, "timestamp" => tweet.timestamp.to_i, "tags" => tweet.tags.to_a)
  end

  ##
  # Returns a collection of tweets created by a given user
  # as an array. The tweets are stored in the array in descending
  # order by timestamp, so the most recent tweets will be first in
  # the array.
  #
  # ===ARGS:
  # - user should be a User object for which to find tweets or a String
  # username.
  # - limit should be the maximum number of tweets you want returned.
  # The default limit is 50.
  def get_tweets_for_user(user, limit = 50)
    result_set = @connection.find("user" => user.is_a?(User) ? user.handle : user).sort([["timestamp", -1]]).limit(limit)
    tweets = []

    result_set.each {|result| tweets << Tweet.new(result["text"], user, result["timestamp"], result["tags"])}
    return tweets
  end

  ##
  # Returns a collection of tweets which have the specified tag
  # as an array. The tweets are stored in the array in descending
  # order by timestamp, so the most recent tweets will be first in
  # the array.
  #
  # ===ARGS:
  # - tag should be a string tag you want to search for.
  # - limit should be the maximum number of tweets you want returned.
  # The default limit is 50.
  def get_tweets_for_tag(tag, limit = 50)
    result_set = @connection.find("tags" => tag).sort([["timestamp", -1]]).limit(limit)
    tweets = []

    result_set.each do |result|
      tweets << Tweet.new(result["text"], result["user"], result["timestamp"], result["tags"])
    end

    return tweets
  end

  ##
  # Get up to limit  tweets from all of a user's followers sorted by most
  # recent tweets.
  #
  # ===ARGS:
  # - User should be the User object from whose followers you want tweets.
  # - limit should be the maximum number of tweets you want returned.
  # The default limit is 50.
  def get_tweets_from_followers(user, limit = 50)
    tweets = []
    user.following.each {|followed| tweets = tweets + self.get_tweets_for_user(followed)}
    tweets.sort! {|t1, t2| t1.timestamp <=> t2.timestamp}
    return tweets[0...limit]
  end
end
