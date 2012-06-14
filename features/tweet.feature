Feature: Posting a Tweet
	 In order for the app to have content users need to be able
	 to post tweets.

	 @javascript
	 Scenario: Post a Tweet as a logged in user
	 	   Given user "BigAl" exists
		   And I am logged in as "BigAl"
	 	   And I am on the user's home page
		   When I fill in "tweet_text" with "Hello, this is a #test tweet!" within "#tweet-box"
		   And I press "Tweet" within "#tweet-box"
		   Then I should see "Hello, this is a #test tweet!" within "#posts"