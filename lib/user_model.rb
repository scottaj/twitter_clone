require 'bundler/setup'
require_relative 'user'
require 'mongo'

class UserModel
  def initialize(connection, collection_name)
    @connection = connection.collection(collection_name)
  end

  def save_user(user)
    if @connection.find_one("_id" => user.handle)
      puts user.modified
      @connection.update({"_id" => user.handle}, {"following" => user.following.to_a}) if user.modified
    else
      @connection.insert("_id" => user.handle, "following" => user.following.to_a)
    end
    user.modified = false
  end

  def get_user_by_handle(handle)
    record = @connection.find_one("_id" => handle)
    return User.new(record["_id"], record["following"]) if record
  end
end
