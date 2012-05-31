require 'set'

# Class representing a Tweet from a user.
class Tweet

  ##
  # Creates a new tweet object.
  #
  # =ARGS:
  # -text sould be a string of the tweet's text.
  # -user can be either a user object or just a string
  # of the user's name.
  # -timestamp is optional. If timestamnp is provided it
  # should be a valid unix timestamp represented as an
  # integer. If timestamp is not provided a ruby Time
  # object will be created at the time of the objects
  # creation.
  # -tags is optional. If tags is provided it should be an
  # array of string representing the tags in the post. If
  # tags is not provided then the tags will be extrated from
  # the tweet text using the hashtag symbol.
  def initialize(text, user, timestamp = nil, tags = nil)
    @text = text

    if user.is_a?(User)
      @user = user.handle
    else
      @user = user
    end

    if timestamp
      @timestamp = Time.at(timestamp)
    else
      @timestamp = Time.now
    end

    if tags
      @tags = Set.new(tags)
    else
      @tags = Set.new
      
      # Extract tags from text, strip hash from tag.
      text.scan(/#\S+/) {|match| @tags << match[/[^#]+/]}
    end
  end

  attr_reader :text, :user, :timestamp, :tags

  ##
  # Overloads the == method for the Tweet class. Equality is determined by the
  # sameness of the user and the timestamp of the tweet. The assumption is that
  # there will only be one tweet in existance for a particular user at a particular
  # point in time.
  #
  # =ARGS:
  # -other should be a tweet object that is being compared.
  def ==(other)
    return true if @user == other.user and @timestamp.to_i == other.timestamp.to_i
    return false
  end
end
