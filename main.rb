require 'bundler/setup'
require 'sinatra'
require 'slim'
require 'mongo'
require 'yaml'
require_relative 'lib/user'
require_relative 'lib/tweet'
require_relative 'lib/user_model'
require_relative 'lib/tweet_model'


class TwitterClone < Sinatra::Base
  
  # Main routing table for application.
  get '/' do
    @page_title = "Home"

    slim :index
  end
end

TwitterClone.run! if __FILE__ == $0
