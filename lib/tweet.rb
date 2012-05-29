require 'set'

class Tweet
  def initialize(text, user)
    @text = text
    @user = user.handle
    @timestamp = Time.now()
    @tags = Set.new()

    # Extract tags from text, strip hash from tag.
    text.scan(/#\S+/) {|match| @tags << match[/[^#]+/]}
  end

  attr_reader :text, :user, :timestamp, :tags
end
