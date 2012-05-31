require 'set'

class Tweet
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

  def ==(other)
    return true if @user == other.user and @timestamp.to_i == other.timestamp.to_i
    return false
  end
end
