require_relative 'tweet_m'
require_relative 'user_m'

# Model class for saving and loading tweets to a mongo database.
class TweetModel

  def tweet(text, user)
    tags = []
    text.scan(/#\S+/) {|match| tags << match[/[^#]+/]}
    Tweet.create(text: text, user: user, timestamp: Time.now.utc, tags: tags)
  end

  
  ##
  # Returns a collection of tweets created by a given user
  # as an enumerable. The tweets are stored in the array in descending
  # order by timestamp, so the most recent tweets will be first in
  # the eumerable.
  #
  # ===ARGS:
  # - user should be a User object for which to find tweets or a String
  # username.
  # - limit should be the maximum number of tweets you want returned.
  # The default limit is 50.
  def get_tweets_for_user(handle, limit = 50)
    tweets = []
    Tweet.where(user: handle).desc(:timestamp).limit(limit).each {|tweet| tweets << tweet}
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
    tweets = []
    Tweet.where(tags: tag).desc(:timestamp).limit(limit).each {|tweet| tweets << tweet}
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
  def get_tweets_from_followers(handle, limit = 50)
    tweets = []
    User.where(handle: handle).first.following.each do |followed|
      tweets = tweets + self.get_tweets_for_user(followed)
    end
    tweets.sort! {|t1, t2| t2.timestamp <=> t1.timestamp}
    return tweets[0...limit]
  end

  def tag_search(tag, limit = 50)
    results = []
    Tweet.where(tags: /#{tag}/i).desc(:timestamp).limit(limit).each do |tweet|
      tweet.tags.each {|ttag| results << "##{ttag}" if ttag.match(/#{tag}/)}
    end
    return results.uniq
  end
end
