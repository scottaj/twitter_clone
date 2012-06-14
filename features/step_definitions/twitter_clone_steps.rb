require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^user "(.*?)" exists$/ do |handle|
  raise "User does not exist!" unless UserModel.new.get_user_by_handle(handle)
end

Given /^user "(.*?)" does not exist$/ do |handle|
  raise "User does, in fact, exist!" if UserModel.new.get_user_by_handle(handle)
end

Given /^I am logged in as "(.*?)"$/ do |handle|
  visit '/login'
  fill_in("handle", with: handle)
  click_button("Go!")

  current_path = URI.parse(current_url).path
  assert_equal('/home', current_path)
end

Given /^"(.*?)" is not following "(.*?)"$/ do |follower, followed|
  
end

Then /^"(.*?)" is following "(.*?)"$/ do |follower, followed|
  
end
