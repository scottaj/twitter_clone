require_relative 'user_m'

# Class for storing and retrieving User objects from a mongo
# database.
class UserModel


  ##
  # Searches for a user handle in the database, uses a regex which
  # ignores the case of the handle. Returns the handle if there is a
  # a match and nil otherwise.
  #
  # ===ARGS:
  # - handle should be a string of the users handle. Case is not relevent.
  def user_exists?(handle)
    return User.where(handle: /^#{handle}$/i).first.handle
  end
    
  ##
  # Queries database for a user with the specified handle, if user
  # exists then an object is generated with the database info and
  # returned.
  #
  # ===ARGS:
  # - handle should be a string of the users handle.
  def get_user_by_handle(handle)
    return User.where(handle: handle).first
  end

  def follow_user(follower, following)
    User.where(handle: follower).push(following: following)
  end

  def unfollow_user(follower, following)
    User.where(handle: follower).pull(following: following)
  end
end
