require_relative 'tweet_m'
require_relative 'user_m'

# Model class for saving and loading tweets to a mongo database.
class TweetModel

  ##
  # Creates a new Tweet and persists it in the data store. The timestamp
  # is autogenerated at the time of creation, and the tag are automatically
  # extracted from the text.
  # Returns the created Tweet.
  #
  # ===ARGS:
  # - text should be the text of the tweet, a String.
  # - user should be a User handle, a String.
  def tweet(text, user)
    tags = []
    text.scan(/#\S+/) {|match| tags << match[/[^#][a-z0-9_-]+/i]}
    Tweet.create(text: text, user: user, timestamp: Time.now.utc, tags: tags)
  end

  
  ##
  # Returns a collection of tweets created by a given user
  # as an array. The tweets are stored in the array in descending
  # order by timestamp, so the most recent tweets will be first in
  # the eumerable.
  #
  # ===ARGS:
  # - handle should be a String user handle.
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
  # - tag should be a string tag you want to search for, without the prepending
  # '#' symbol.
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
  # - handle should be a String user handle.
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

  ##
  # Find "trending" tags over the last n tweets. Searches up to limit
  # tweets and aggregates their tags into a 2d array of [tag, count] pairs
  # sorted by highest tag count.
  #
  # ===ARGS:
  # - limit should be the maximum number of tweets you want searched.
  # The default limit is 100.
  def trending_tags(limit = 100)
    tags = {}
    Tweet.where().desc(:timestamp).limit(limit).each do |tweet|
      tweet.tags.each do |tag|
        if tags[tag]
          tags[tag] += 1
        else
          tags[tag] = 1
        end
      end
    end
    return tags.to_a.sort {|x, y| y[1] <=> x[1]}
  end
  
  ##
  # Search all tweets starting with the most recent for a tag that matches
  # the provided query. Up to limit Tweets will be checked, however since
  # the same tag may match for more that one tweet, less than limit results
  # may be returned. Conversely, since more that one tag in a Tweet may match
  # the regex, more than limit results may be returned. An array of all
  # discovered matching tags is returned with no duplicates.
  #
  # ===ARGS:
  # - tag should be a string to searchto search for using regex.
  # - limit should be the maximum number of tweets you want returned.
  # The default limit is 50.
  def tag_search(tag, limit = 50)
    results = []
    Tweet.where(tags: /#{tag}/i).desc(:timestamp).limit(limit).each do |tweet|
      tweet.tags.each {|ttag| results << "##{ttag}" if ttag.match(/#{tag}/)}
    end
    return results.uniq
  end
end
