Feature: Search for users or tags

	 @javascript
	 Scenario: Search an existing user
	 	   Given user BigAl exists
		   And user -__- exists
		   And I am logged in as BigAl
		   And I am on the user's home page
		   When I fill in "searchq" with "-__-" within "#search"
		   And I submit the form
		   Then I should be on -__-'s real page

	 @javascript
	 Scenario: Search a non-existant user
	 	   Given user BigAl exists
		   And user 007 does not exist
		   And I am logged in as BigAl
		   And I am on the user's home page
		   When I fill in "searchq" with "007" within "#search"
		   And I submit the form
		   Then I should be on the search page
		   And I should see "User 007 not found!"

	 @javascript
	 Scenario: Search an existing hashtag
	 	   Given user BigAl exists
		   And I am logged in as BigAl
		   And I am on the user's home page
		   When I fill in "tweet_text" with "Hello, this is a #test tweet!" within "#tweet-box"
		   And I press "Tweet" within "#tweet-box"
		   And I fill in "searchq" with "#test" within "#search"
		   And I submit the form
		   Then I should be on the #test real page
		   And I should see "Hello, this is a #test tweet!" within "#feed"
		   
	 @javascript
	 Scenario: Search a non existant hashtag
	 	   Given user BigAl exists
		   And I am logged in as BigAl
		   And I am on the user's home page
		   When I fill in "searchq" with "#bro" within "#search"
		   And I submit the form
		   Then I should be on the search page
		   And I should see "#bro not found!"