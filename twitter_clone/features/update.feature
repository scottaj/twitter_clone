Feature: Automatically updating pages
	 Pages with tweets should update automatically at a set
	 interval so that users do not have to refresh to see new
	 content

	 @javascript
	 Scenario: News feed updates
	 	   Given user BigAl exists
		   And user -__- exists
		   And BigAl follows -__-
		   		   
		   When I am in browser 1
		   And I am logged in as BigAl
		   And I am on the user's home page
		   Then I should not see "Hi there!" within "#news"

		   When I am in browser 2
		   And I am logged in as -__-
		   And I am on the user's home page
		   Then I should see "-__-" within "#name"
		   When I fill in "tweet_text" with "Hi there!" within "#tweet-box"
		   And I press "Tweet" within "#tweet-box"
		   Then I should see "Hi there!" within "#posts"

		   When I am in browser 1
		   Then I should see "BigAl" within "#name"
		   When I wait 8 seconds
		   Then I should see "Hi there!" within "#news"

	@javascript
	Scenario: User page updates
		  Given user BigAl exists
		  And user -__- exists
		  
		  When I am in browser 1
		  And I am logged in as BigAl
		  And I go to -__-'s profile page
		  Then I should not see "Howdy" within "#feed"
		  
		  When I am in browser 2
		  And I am logged in as -__-
		  And I am on the user's home page
 		  When I fill in "tweet_text" with "Howdy" within "#tweet-box"
		  And I press "Tweet" within "#tweet-box"
		  Then I should see "Howdy" within "#posts"
		  
		  When I am in browser 1
		  And I wait 8 seconds
		  Then I should see "Howdy" within "#feed"

	@javascript
	Scenario: Tag page updates
		  Given user BigAl exists
		  And user -__- exists
		  
		  When I am in browser 1
		  And I am logged in as BigAl
		  And I go to the #test tag page
		  Then I should not see "#test tweet" within "#feed"

		  When I am in browser 2
		  And I am logged in as -__-
		  And I am on the user's home page
 		  When I fill in "tweet_text" with "#test tweet" within "#tweet-box"
		  And I press "Tweet" within "#tweet-box"
		  Then I should see "#test tweet" within "#posts"

		  When I am in browser 1
		  And I wait 8 seconds
		  Then I should see "#test tweet" within "#feed"