require 'bundler/setup'
require 'sinatra'
require 'slim'
require 'mongo'
require 'yaml'
require_relative 'lib/user'
require_relative 'lib/tweet'
require_relative 'lib/user_model'
require_relative 'lib/tweet_model'

##
# Main application class for sinatra application.
class TwitterClone < Sinatra::Base

  ##
  # ==App configuration
  # - Enables sessions
  # - Creates database connection and uses that to create models
  # for tweets and users.
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

    @@user_model = UserModel.new(db_conn, db_settings[:user_collection])
    @@tweet_model = TweetModel.new(db_conn, db_settings[:tweet_collection])
  end

  ##
  # Main routing table for application.
  before /^(?!\/(login|signup)).*$/i do
    redirect '/login' unless session[:user]
    @navbar_option = "/logout"
    @navbar_text = "Logout"
  end
  
  before "/login" do
    redirect '/' if session[:user]
    @navbar_option = "/signup"
    @navbar_text = "Sign Up"
  end

  before "/signup" do
    redirect '/' if session[:user]
    @navbar_option = "/login"
    @navbar_text = "Login"
  end
  
  get '/' do
    redirect '/home'
  end

  get '/home' do
    page_user = @@user_model.get_user_by_handle(session[:user])
    user_tweets = @@tweet_model.get_tweets_for_user(page_user)
    slim :index, locals: {page_title: session[:user],
      handle: session[:user],
      page_user: page_user,
      user_tweets: user_tweets}
  end

  post '/home' do
    @@user_model.get_user_by_handle(session[:user]).tweet(params[:tweet_text], @@tweet_model)
    redirect '/home'
  end  

  get '/users/:handle' do
    
  end

  get '/tags/:tag' do
    
  end

  get '/login' do
    slim :login, locals: {page_title: "Login", message: ""}
  end

  post '/login' do
    handle = @@user_model.user_exists?(params[:handle])
    if handle
      session[:user] = handle
      redirect '/'
    else
      slim :login, locals: {page_title: "Login", message: "User handle not found!"}
    end
  end

  get '/signup' do
    slim :signup, locals: {page_title: "Sign Up", message: ""}
  end

  post '/signup' do
    exists = @@user_model.user_exists?(params[:handle])
    if exists
      slim :signup, locals: {page_title: "Sign Up", message: "Selected handle is already in use by someone else!"}
    else
      @@user_model.save_user(User.new(params[:handle]))
      redirect '/'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  post '/:id' do
    
  end
end



TwitterClone.run! if __FILE__ == $0
