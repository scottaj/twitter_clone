require 'set'
require_relative 'tweet.rb'

# Class representing an individual user.
class User
  def initialize(handle)
    @handle = handle
    @following = Set.new()
  end

  attr_reader :handle, :following

  # Follow a users tweets.
  def follow_user(user)
    @following << user.handle
  end

  # Unfollow a users tweets.
  def unfollow_user(user)
    @following.delete_if {|handle| handle == user.handle}
  end

  def tweet(text)
    return Tweet.new(text, self)
  end

  def serialize()
    return {:doctype => :user, :document => {:_id => @handle, :following => @following}}
  end
end
