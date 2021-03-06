Feature: login
	In order to access the Twitter Clone application
	I want to be able to login using a user handle
	
	Scenario: Log in with an existing user handle
		  Given I am on the login page
		  And user BigAl exists
		  When I fill in "handle" with "BigAl" within "#login"
		  And I press "Go!" within "#login"
		  Then I should be on the user's homepage
		  And I should see "BigAl"

	Scenario: Non-existant user handle prevents login
		  Given I am on the login page
		  And user 007 does not exist
		  When I fill in "handle" with "007" within "#login"
		  And I press "go" within "#login"
		  Then I should be on the login page
		  And I should see "User handle not found!"

	Scenario: Logout a logged in user.
		  Given user BigAl exists
		  And I am logged in as BigAl
		  When I follow "Logout" within "#navbar"
		  Then I should be on the login page