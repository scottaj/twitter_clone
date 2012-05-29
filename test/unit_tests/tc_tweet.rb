require 'test/unit'
require_relative '../../lib/tweet.rb'
require_relative '../../lib/user.rb'

class TestUser < Test::Unit::TestCase
  def setup()
    user = User.new("Jimbo")
    text_1 = "Got super plastered last night!"
    text_2 = "Got soooo #wasted last night!"
    text_3 = "Got super #drunk last night! #partyrocker #brolife"
    @tweet_1 = Tweet.new(text_1, user)
    @tweet_2 = Tweet.new(text_2, user)
    @tweet_3 = Tweet.new(text_3, user)
  end

  def test_tag_extraction
    assert_equal(Set.new(), @tweet_1.tags, "Testing tweet that should have no tags.")
    assert_equal(Set.new(["wasted"]), @tweet_2.tags, "Testing tweet with 1 interpolated tag.")
    assert_equal(Set.new(["drunk", "partyrocker", "brolife"]), @tweet_3.tags, "testing tweet with multiple tags including endtags.")
  end
end
