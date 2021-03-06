class TwitterClone < Padrino::Application
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions
  set :session_secret, "AMAZINGH0rS3!"
    
  # Mongoid.configure do |config|
  #   if ENV['MONGOHQ_URL']
  #     uri = URI.parse(ENV['MONGOHQ_URL'])
  #     conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
  #     db = conn.db(uri.path.gsub(/^\//, ''))
  #     config.master = db
  #   elsif ENV['RACK_ENV'] == 'test'
  #     config.master = Mongo::Connection.new.db("twitter_app_testing")
  #   else
  #     config.master = Mongo::Connection.new.db("twitter_app")
  #   end
  # end
  
  Slim::Engine.set_default_options :pretty => true
  
  @@user_model = UserModel.new()
  @@tweet_model = TweetModel.new()

  helpers do
    def validate_tweet_user_tags(tweet_list)
      valid = []
      tagged = []
      tweet_list.each {|tweet| tagged = tagged | tweet.text.scan(/@[a-z0-9_-]+/i)}
      tagged.each {|user| valid << user if @@user_model.user_exists?(user[/[^@]+/])}
      return valid.uniq
    end
  end

  ##
  # Main routing table for application.
  before do
    @navbar_option = "/logout"
    @navbar_text = "Logout"
  end
  
  before /^(?!\/(login|signup|update)).*$/i do
    redirect '/login' unless session[:user]
  end

  get '/' do
    redirect '/home'
  end
  
  get '/:handle' do
    if session[:user_page] == params[:handle]
      session[:user_page] = nil
      handle = @@user_model.user_exists?(params[:handle])
      page_user = @@user_model.get_user_by_handle(handle)
      tweets = @@tweet_model.get_tweets_for_user(handle)
      following = @@user_model.following?(session[:user], handle)
      validated = validate_tweet_user_tags(tweets)
      
      render :user, layout: :layout, locals: {page_title: handle,
        handle: handle,
        page_user: page_user,
        offset: request.cookies["offset"],
        tweets: tweets,
        following: following,
        validated: validated}
    else
      pass
    end
  end

  get '/:tag' do
    if session[:tag_page] == params[:tag][/[^#]+/]
      tweets = @@tweet_model.get_tweets_for_tag(session[:tag_page])
      validated = validate_tweet_user_tags(tweets)
      session[:tag_page] = nil
      
      render :tag, layout: :layout, locals: {page_title: params[:tag],
        tag: "##{params[:tag]}",
        offset: request.cookies["offset"],
        tweets: tweets,
        validated: validated}
    else
      pass
    end
  end

  get '/home' do
    page_user = @@user_model.get_user_by_handle(session[:user])
    not_following = @@user_model.find_not_following(session[:user]).shuffle
    trending = @@tweet_model.trending_tags()
    user_tweets = @@tweet_model.get_tweets_for_user(session[:user])
    followed_tweets = @@tweet_model.get_tweets_from_followers(session[:user])
    validated = validate_tweet_user_tags(user_tweets) | validate_tweet_user_tags(followed_tweets)
    render :index, layout: :layout, locals: {page_title: session[:user],
      handle: session[:user],
      page_user: page_user,
      not_following: not_following,
      trending: trending,
      offset: request.cookies["offset"],
      user_tweets: user_tweets,
      followed_tweets: followed_tweets,
      validated: validated}
  end

  post '/home' do
    @@tweet_model.tweet(params[:tweet_text], session[:user])
    redirect '/home'
  end  

  get '/login' do
    @navbar_option = "/signup"
    @navbar_text = "Sign Up"
    unless session[:user]
      render :login, layout: :layout, locals: {page_title: "Login", message: ""}
    else
      redirect '/'
    end
  end

  post '/login' do
    @navbar_option = "/signup"
    @navbar_text = "Sign Up"
    handle = @@user_model.user_exists?(params[:handle])
    if handle
      session[:user] = handle
      redirect '/'
    else
      render :login, layout: :layout, locals: {page_title: "Login", message: "User handle not found!"}
    end
  end

  get '/signup' do
    @navbar_option = "/login"
    @navbar_text = "Login"
    render :signup, layout: :layout, locals: {page_title: "Sign Up", message: ""}
  end

  post '/signup' do
    @navbar_option = "/login"
    @navbar_text = "Login"
    exists = @@user_model.user_exists?(params[:handle])
    if exists
      render :signup, layout: :layout, locals: {page_title: "Sign Up", message: "Selected handle is already in use by someone else!"}
    else
      if params[:handle].match(/^[a-z0-9_-]+$/i)
        User.create(handle: params[:handle], following: [])
        redirect '/'
      else
        render :signup, layout: :layout, locals: {page_title: "Sign Up", message: "Selected handle has invalid characters!"}
      end
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  post '/follow' do
    if @@user_model.following?(session[:user], params[:handle])
      @@user_model.unfollow_user(session[:user], params[:handle])
    else
      @@user_model.follow_user(session[:user], params[:handle])
    end
    redirect "/#{params[:handle]}" unless params[:no_redirect]
  end

  get '/search' do
    begin
      query = params[:searchq][/\S+/]
      if query.match(/#.+/)
        query = query[/[^#]+/]
        redirect "/tags/#{query}" if @@tweet_model.get_tweets_for_tag(query, 1).length == 1
        render :bad_search, layout: :layout, locals: {page_title: "No Results Found", query: "##{query}"}
      elsif query.match(/.+/)
        redirect "/users/#{query}" if @@user_model.user_exists?(query)
        render :bad_search, layout: :layout, locals: {page_title: "No Results Found", query: "User #{query}"}
      end
    rescue NoMethodError
      render :bad_search, layout: :layout, locals: {page_title: "No Query Provided", query: "Page"}
    end
  end  
  
  get '/users/:handle' do
    handle = @@user_model.user_exists?(params[:handle])
    redirect '/home' if handle == session[:user]
    session[:user_page] = handle
    redirect "/#{handle}"
  end

  get '/tags/:tag' do
    session[:tag_page] = params[:tag][/[^#]+/]
    redirect "/#{params[:tag]}"
  end

  post '/update/tweet' do
    @@tweet_model.tweet(params[:tweet_text], session[:user])
    tweets = @@tweet_model.get_tweets_for_user(session[:user])
    render :tweet_list, layout: :layout, layout: false, locals: {title: "My Tweets",
      id: "user",
      offset: request.cookies["offset"],
      tweets: tweets,
      validated: validate_tweet_user_tags(tweets)}
  end

  post '/update/check' do
    if params[:type] == "news"
      tweet = @@tweet_model.get_tweets_from_followers(session[:user], 1)[0]
    elsif params[:type] == "user"
      tweet = @@tweet_model.get_tweets_for_user(params[:param], 1)[0]
    elsif params[:type] == "tag"
      tweet = @@tweet_model.get_tweets_for_tag(params[:param][/[^#]+/], 1)[0]
    end
    if tweet
      return "t" if (Time.now.to_i - tweet.timestamp.to_i) <= 70
    end
    return "f"
  end

  post '/update/news' do
    tweets = @@tweet_model.get_tweets_from_followers(params[:handle])
    render :tweet_list, layout: false, locals: {title: "What's Happening",
      id: "tweets",
      offset: request.cookies["offset"],
      tweets: tweets,
      validated: validate_tweet_user_tags(tweets)}
  end

  post '/update/user' do
    tweets = @@tweet_model.get_tweets_for_user(params[:handle])
    render :tweet_list, layout: false, locals: {title: params[:handle],
      id: "tweets",
      offset: request.cookies["offset"],
      tweets: tweets,
      validated: validate_tweet_user_tags(tweets)}
  end

  post '/update/tag' do
    tweets = @@tweet_model.get_tweets_for_tag(params[:tag][/[^#]+/])
    render :tweet_list, layout: false, locals: {title: "Tweets with tag #{params[:tag]}",
      id: "tweets",
      offset: request.cookies["offset"],
      tweets: tweets,
      validated: validate_tweet_user_tags(tweets)}
  end

  post '/update/complete' do
    if params[:query].match(/^#\S+$/)
      data = JSON::dump(@@tweet_model.tag_search(params[:query][/[^#]+/]))
    elsif params[:query].match(/^\S+$/)
      data = JSON::dump(@@user_model.user_search(params[:query]))
    else
      data = JSON::dump([])
    end
    content_type "application/json"
    data
  end

  get '/:id' do
    redirect "/search?searchq=#{params[:id]}"
  end
end
