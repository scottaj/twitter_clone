# Ruby Web Project

##Assignment

Develop and deploy a Twitter clone.

###Features:

As a logged-in user I can:
Tweet
Read my tweets
Read tweets from other users
Search for tweets based on tags
Follow/unfollow other users
See who I’m following
See the Tweets of the people I’m following

###Constraints:

Back-end in Sinatra
Data in MongoDB
Front-end in Bootstrap
Deploy to Heroku

###Scenarios:

(preliminary): Sign-in
I can sign-in by clicking “Sign In” on any page, and entering my handle.  (Skip password auth for now.)  I should land on my home page
Visit http://yourapp.heroku.com
Click”Sign In”
Enter “jones” for my handle
See my home page, which is at http://yourapp.heroku.com/home

A. View my own tweets. 
I go to my home page and see all of my tweets in date-descending order (most recent tweet on top, oldest tweet below), limited to my 50 most recent tweets.
Visit http://yourapp.heroku.com/home
See my tweets



B. View someone else’s tweets. 
I visit someone else’s tweet page and see their 50 most recent tweets, sorted date-descending.
Visit http://yourapp.heroku.com/croz 
See croz’s name as title of page
See croz’s 50 most recent tweets

C. Search all tweets by tag.
Tags are words within a tweet that start with a “#” character.  Eg “I’m going to #founders after work”.  I can search for all #founders-related tweets by 
searching for “#founders”.
From my homepage
Enter “#founders” in the search box
See “#founders” in the title of the search results page
See 50 most recent tweets mentioning #founders

D. Follow another user
I can “follow” a user by clicking “Follow” near their name on their tweet page.  On my homepage, I should see a list of the 50 most recent tweets across all 
people I’m following, in a section called What’s Happening.  (My home used to show me my own tweets, but now I expect these to be displayed AFTER the tweets from 
people I’m following, in a separate section called My Tweets.)
Visit http://yourapp.heroku.com/croz
Click “Follow croz”
Visit http://yourapp.herou.com/68
Click “Follow 68”
Go home
See recent tweets from croz and 68 under What’s Happening

E. Un-follow a user
I can unfollow a user by going to their page and clicking “Unfollow X.”  (This link appears where I’d normally see “Follow X”.  I don’t want to see their tweets 
in my stream on my homepage anymore.
(Assumes: following croz and 68)
Visit http://yourapp.heroku.com/croz
Click “Unfollow Croz”
Go home 
See 68 tweets in What’s Happening
DO NOT SEE croz tweets in What’s Happening
