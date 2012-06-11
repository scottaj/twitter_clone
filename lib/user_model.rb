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
  # Follow a user.
  #
  # ===ARGS:
  # - follower is the handle of a user who is doing the following of a
  # new user, a String.
  # - following is the handle of a user who is being followed, a String.
  def follow_user(follower, following)
    User.where(handle: follower).first.push(:following, following)
  end

  ##
  # Unfollow a user.
  #
  # ===ARGS:
  # - follower is the handle of a user who is doing the unfollowing of a
  # followed user, a String.
  # - following is the handle of a user who is being followed, a String.
  def unfollow_user(follower, following)
    User.where(handle: follower).first.pull(:following, following)
  end

  ##
  # Returns true if a user is being followed, false otherwise.
  #
  # ===ARGS:
  # - follower is the handle of a user who is doing the following of a
  # new user, a String.
  # - following is the handle of a user who is being followed, a String.
  def following?(follower, following)
    return true if User.where(handle: follower, following: following).first
    return false
  end

  def find_not_following(handle, limit = 10)
    not_followed = []
    followed = User.where(handle: handle).first.following
    followed << handle
    User.not_in(handle: followed).limit(limit).each {|u| not_followed << u.handle}
    return not_followed
  end

  ##
  # Search all users for a handle that matches the provided sting via
  # regex. Returns up to limit matching users in no partiucular order.
  #
  # ===ARGS:
  # - handle is a search query to search existing handles for a match
  # to, a String.
  # - limit should be the maximum number of User handles you want returned.
  # The default limit is 50.
  def user_search(handle, limit = 50)
    results = []
    User.where(handle: /#{handle}/i).limit(limit).each do |user|
      results << user.handle
    end
    return results
  end
end
