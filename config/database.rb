
# Connection.new takes host, port

# You can also configure Mongoid this way
# Mongoid.configure do |config|
#   name = @settings["database"]
#   host = @settings["host"]
#   config.master = Mongo::Connection.new.db(name)
#   config.slaves = [
#     Mongo::Connection.new(host, @settings["slave_one"]["port"], :slave_ok => true).db(name),
#     Mongo::Connection.new(host, @settings["slave_two"]["port"], :slave_ok => true).db(name)
#   ]
# end
#
# More installation and setup notes are on http://mongoid.org/docs/
Mongoid.configure do |config|
  if ENV['MONGOHQ_URL']
    uri = URI.parse(ENV['MONGOHQ_URL'])
    conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
    db = conn.db(uri.path.gsub(/^\//, ''))
    config.master = db
  elsif ENV['RACK_ENV'] == 'test'
    config.master = Mongo::Connection.new.db("twitter_app_testing")
  else
    host = 'localhost'
    port = Mongo::Connection::DEFAULT_PORT

    database_name = case Padrino.env
                    when :development then 'twitter_app'
                    when :production  then 'twitter_app'
                    when :test        then 'twitter_app_testing'
                    end

    config.master = Mongo::Connection.new(host, port).db(database_name)
  end	
end
