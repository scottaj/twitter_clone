require 'set'
require_relative 'tweet.rb'

# Class representing an individual user.
class User
  def initialize(handle, following = Set.new)
    @handle = handle
    @following = following
    @modified = false
  end

  attr_reader :handle, :following
  attr_accessor :modified

  # Follow a users tweets.
  def follow_user(user)
    @following << user.handle
    @modified = true
  end

  # Unfollow a users tweets.
  def unfollow_user(user)
    @following.delete_if {|handle| handle == user.handle}
    @modified = true
  end

  def tweet(text)
    return Tweet.new(text, self)
  end
end
