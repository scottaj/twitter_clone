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

  configure do
    enable :sessions
    
    db_settings = YAML::load(File.open('./db.conf', 'r'))

    if db_settings[:hostname] or db_settings[:port]
      if db_settings[:port]
        db_conn = Mongo::Connection.new(db_settings[:hostname], db_settings[:port]).db(db_settings[:database])
      else
        db_conn = Mongo::Connection.new(db_settings[:hostname]).db(db_settings[:database])
      end
    else
      db_conn = Mongo::Connection.new.db(db_settings[:database])
    end

    db_conn.authenticate(db_settings[:username], db_settings[:password]) if db_settings[:username]

    @user_model = UserModel.new(db_conn, db_settings[:user_collection])
    @tweet_model = TweetModel.new(db_conn, db_settings[:tweet_collection])
  end
  
  # Main routing table for application.
  get '/' do
    test = "Home"
    slim :index, locals: {page_title: test}
  end
end

TwitterClone.run! if __FILE__ == $0
