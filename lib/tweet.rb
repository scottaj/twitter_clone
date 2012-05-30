require 'set'

class Tweet
  def initialize(text, user, timestamp = Time.now, tags = nil)
    @text = text
    @user = user.handle
    @timestamp = timestamp

    if tags
      @tags = tags
    else
      @tags = Set.new
      
      # Extract tags from text, strip hash from tag.
      text.scan(/#\S+/) {|match| @tags << match[/[^#]+/]}
    end
  end

  attr_reader :text, :user, :timestamp, :tags
end
