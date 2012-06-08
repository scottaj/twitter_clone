require 'bundler/setup'
require 'sinatra'
require 'slim'
require 'mongoid'
require 'yaml'
require 'uri'
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
    
    Mongoid.configure do |config|
      if ENV['MONGOHQ_URL']
        uri = URI.parse(ENV['MONGOHQ_URL'])
        conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
        db = conn.db(uri.path.gsub(/^\//, ''))
        config.master = db
      else
        config.master = Mongo::Connection.new.db("rcr_app")
      end
    end

    @@user_model = UserModel.new()
    @@tweet_model = TweetModel.new()
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
    user_tweets = @@tweet_model.get_tweets_for_user(session[:user])
    followed_tweets = @@tweet_model.get_tweets_from_followers(session[:user])
    slim :index, locals: {page_title: session[:user],
      handle: session[:user],
      page_user: page_user,
      offset: request.cookies["offset"],
      user_tweets: user_tweets,
      followed_tweets: followed_tweets}
  end

  post '/home' do
    @@tweet_model.tweet(params[:tweet_text], session[:user])
    redirect '/home'
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
      User.create(handle: params[:handle], following: [])
      redirect '/'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  post '/follow' do
    if @@user_model.following?(session[:user], session[:user_page])
      @@user_model.unfollow_user(session[:user], session[:user_page])
    else
      @@user_model.follow_user(session[:user], session[:user_page])
    end
    redirect "/#{session[:user_page]}"
  end

  get '/search' do
    query = params[:searchq][/\S+/]
    if query[/#.+/]
      query = query[/[^#]+/]
      redirect "/tags/#{query}" if @@tweet_model.get_tweets_for_tag(query, 1).length == 1
      slim :bad_search, locals: {page_title: "No Results Found", query: "##{query}"}
    else
      redirect "/users/#{query}" if @@user_model.user_exists?(query)
      slim :bad_search, locals: {page_title: "No Results Found", query: "User #{query}"}
    end
  end  
  
  get '/users/:handle' do
    handle = @@user_model.user_exists?(params[:handle])
    redirect '/home' if handle == session[:user]
    session[:user_page] = handle
    session[:tag_page] = nil
    redirect "/#{handle}"
  end

  get '/tags/:tag' do
    session[:tag_page] = params[:tag][/[^#]+/]
    session[:user_page] = nil
    redirect "/#{params[:tag]}"
  end

  post '/tweet' do
    @@tweet_model.tweet(params[:tweet_text], session[:user])
    slim :tweet_list, layout: false, locals: {title: "My Tweets",
      id: "user",
      offset: request.cookies["offset"],
      tweets: @@tweet_model.get_tweets_for_user(session[:user])}
  end

  post '/update/check' do
    if params[:type] == "news"
      tweet = @@tweet_model.get_tweets_from_followers(session[:user], 1)[0]
    elsif params[:type] == "user"
      tweet = @@tweet_model.get_tweets_for_user(params[:param], 1)[0]
    elsif params[:type] == "tag"
      tweet = @@tweet_model.get_tweets_for_tag(params[:param], 1)[0]
    end
    if tweet
      return "t" if (Time.now.to_i - tweet.timestamp.to_i) <= 70
    end
    return "f"
  end

  post '/update/news' do
    slim :tweet_list, layout: false, locals: {title: "What is Happening",
      id: "tweets",
      offset: request.cookies["offset"],
      tweets: @@tweet_model.get_tweets_from_followers(params[:handle])}
  end

  post '/update/user' do
    slim :tweet_list, layout: false, locals: {title: params[:handle],
      id: "tweets",
      offset: request.cookies["offset"],
      tweets: @@tweet_model.get_tweets_for_user(params[:handle])}
  end

  post '/update/tag' do
    
  end

  get '/:id' do
    if session[:user_page] == params[:id]
      handle = page_user = @@user_model.user_exists?(params[:id])
      page_user = @@user_model.get_user_by_handle(handle)
      tweets = @@tweet_model.get_tweets_for_user(handle)
      following = @@user_model.following?(session[:user], handle)
      slim :user, locals: {page_title: handle,
        handle: handle,
        page_user: page_user,
        offset: request.cookies["offset"],
        tweets: tweets,
        following: following}
    elsif session[:tag_page] == params[:id][/[^#]+/]
      tweets = @@tweet_model.get_tweets_for_tag(session[:tag_page])
      slim :tag, locals: {page_title: params[:id],
        tag: "##{params[:id]}",
        offset: request.cookies["offset"],
        tweets: tweets}
    else
      redirect "/search?searchq=#{params[:id]}"
    end
  end
end


if __FILE__ == $0
  port = `echo $PORT`.to_i
  TwitterClone.run! :port => port > 0 ? port : 4567
end
