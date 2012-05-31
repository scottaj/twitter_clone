require 'bundler/setup'
require 'sinatra'


class TwitterClone< Sinatra::Base
  # Main routing table for application.
  get '/' do
  
  end
end


TwitterClone.run if __FILE__ == $0
