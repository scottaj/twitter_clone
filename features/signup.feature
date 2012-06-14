Feature: Signup
	 So user can create profiles to begin using the Twitter
	 Clone, they should be able to sign up with a user handle

	 Scenario: Sign up with new user handle
	 	   Given I am on the signup page
		   And user "HandyMan" does not exist
		   When I fill in "handle" with "HandyMan" within "#signup"
		   And I press "Sign Up!" within "#signup"
		   Then I should be on the login page
		   And user "HandyMan" exists

	Scenario: Sign up fails if you enter existing handle
		  Given I am on the signup page
		  And user "BigAl" exists
		  When I fill in "handle" with "BigAl" within "#signup"
		  And I press "Sign Up!" within "#signup"
		  Then I should be on the signup page
		  And I should see "Selected handle is already in use by someone else!"

	Scenario: Sign up fails if you enter a handle with invalid characters
		  Given I am on the signup page
		  And user ":-P" does not exist
		  When I fill in "handle" with ":-P" within "#signup"
		  And I press "Sign Up!" within "#signup"
		  Then I should be on the signup page
		  And I should see "Selected handle has invalid characters!"