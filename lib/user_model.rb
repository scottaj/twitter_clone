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
    user = User.where(handle: /^#{handle}$/i).first
    return user.handle if user
    return user
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

  ##
  # 
  def follow_user(follower, following)
    User.where(handle: follower).first.push(:following, following)
  end

  def unfollow_user(follower, following)
    User.where(handle: follower).first.pull(:following, following)
  end

  def following?(follower, following)
    return true if User.where(handle: follower, following: following).first
    return false
  end

  def user_search(handle, limit = 50)
    results = []
    User.where(handle: /#{handle}/i).limit(limit).each do |user|
      results << user.handle
    end
    return results
  end
end
