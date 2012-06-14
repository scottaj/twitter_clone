# Taken from the cucumber-rails project.

module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/i
      '/'
    when /the log\s?in page/i
      '/login'
    when /the sign\s?up page/i
      '/signup'
    when /the user('s)? home\s?page/i
      '/home'
    when /([a-z0-9_-]+)'s profile page/i
      '/users/#{$1}'
    when /the #[a-z0-9_-]+ tag page/i
      '/tags/#{$1}'
    when /the log\s?out page/i
      '/logout'
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
