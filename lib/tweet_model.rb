require 'bundler/setup'
require_relative 'tweet'
require 'mongo'


class TweetModel
  def initialize(connection, collection_name, user_model)
    @connection = connection.collection(collection_name)
  end

  def save_tweet(tweet)
    @connection.insert("text" => tweet.text, "user" => tweet.user, "timestamp" => tweet.timestamp.to_i, "tags" => tweet.tags.to_a)
  end

  def get_tweets_for_user(user, limit = 50)
    result_set = @connection.find("user" => user.handle).sort([["timestamp", -1]]).limit(limit)
    tweets = []

    result_set.each {|result| tweets << Tweet.new(result["text"], user, result["timestamp"], result["tags"])}
    return tweets
  end

  def get_tweets_for_tag(tag, limit = 50)
    result_set = @connection.find("tags" => tag).sort([["timestamp", -1]]).limit(limit)
    tweets = []

    result_set.each do |result|
      tweets << Tweet.new(result["text"], result["user"], result["timestamp"], result["tags"])
    end

    return tweets
  end
end
