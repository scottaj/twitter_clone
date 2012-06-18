Feature: Follow/unfollow a user
	 
	 @javascript
	 Scenario: Follow another user
	 	   Given user BigAl exists
		   And user -__- exists
		   And I am logged in as BigAl
		   And BigAl is not following -__-
		   When I go to -__-'s profile page
		   And I press "Follow" within "#follow"
		   Then I should see "Unfollow" within "#follow"
		   And BigAl is following -__-
	
	@javascript
	Scenario: Unfollow another user
		  Given user BigAl exists
		  And user -__- exists
		  And I am logged in as -__-
		  And -__- is following BigAl
		  When I go to BigAl's profile page
		  And I press "Unfollow" within "#follow"
		  Then I should see "Follow" within "#follow"
		  And -__- is not following BigAl

	Scenario: See followed user in followed list
		  Given user BigAl exists
		  And user -__- exists
		  And I am logged in as -__-
		  And -__- is following BigAl
		  When I go to the user's home page
		  Then I should see "BigAl" within "#user_box"