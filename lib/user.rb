require 'set'
require_relative 'tweet.rb'

# Class representing an individual user.
class User

  ##
  # Creates a new User object.
  #
  # ===ARGS:
  # - handle should be a string representing the user's handle.
  # - following can be an array of user handles that the user is
  # following. If following is not provided then it is initialized
  # to an empty set.
  def initialize(handle, following = nil)
    @handle = handle
    @modified = false

    if following
      @following = Set.new(following)
    else
      @following = Set.new
    end  
  end

  attr_reader :handle, :following
  attr_accessor :modified

  ##
  # Follow a users tweets.
  #
  # ===ARGS:
  # - user should be a user object to follow.
  def follow_user(user)
    @following << user.handle
    @modified = true
  end

  ##
  # Unfollow a users tweets.
  #
  # ===ARGS:
  # - user should be a user object to unfollow.
  def unfollow_user(user)
    @following.delete_if {|handle| handle == user.handle}
    @modified = true
  end

  ##
  # Issue a tweet for the user. Creates and returns a
  # Tweet object and also saves the tweet using the
  # provided model class.
  #
  # ===ARGS
  # - text should be a string of the tweet's text.
  # - model should be a storage model class that knows
  # how to save a tweet.
  def tweet(text, model)
    tweet = Tweet.new(text, self)
    model.save_tweet(tweet)
    return tweet
  end
end
