require 'bundler/setup'
require_relative 'user'
require 'mongo'

# Class for storing and retrieving User objects from a mongo
# database.
class UserModel

  ##
  # Create a new user model.
  #
  # ===ARGS:
  # - connection should be a Mongo database connection.
  # - collection_name should be the name of a collection within the database.
  def initialize(connection, collection_name)
    @connection = connection.collection(collection_name)
  end

  ##
  # Save a user object to a mongo database.
  #
  # If a user does not exist in the database they are added, if they
  # do exist then the existing record is modified.
  #
  # ===ARGS:
  # - user should be a user object to be saved.
  def save_user(user)
    if @connection.find_one("_id" => user.handle)
      puts user.modified
      @connection.update({"_id" => user.handle}, {"following" => user.following.to_a}) if user.modified
    else
      @connection.insert("_id" => user.handle, "following" => user.following.to_a)
    end
    user.modified = false
  end

  ##
  # Searches for a user handle in the database, uses a regex which
  # ignores the case of the handle. Returns the handle if there is a
  # a match and nil otherwise.
  #
  # ===ARGS:
  # - handle should be a string of the users handle. Case is not relevent.
  def user_exists?(handle)
    result = @connection.find_one("_id" => /^#{handle}$/i)
    return result["_id"] if result
    return nil
  end
    
  ##
  # Queries database for a user with the specified handle, if user
  # exists then an object is generated with the database info and
  # returned.
  #
  # ===ARGS:
  # - handle should be a string of the users handle.
  def get_user_by_handle(handle)
    record = @connection.find_one("_id" => handle)
    return User.new(record["_id"], record["following"]) if record
  end
end
