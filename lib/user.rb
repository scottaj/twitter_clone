

class User
  def initialize(handle)
    @handle = handle
    @following = []
  end

  attr_reader :handle

  def follow_user(user)
    @following << user.handle
  end
  
  def unfollow_user(user)
    @following.delete_if {|handle| handle == user.handle}
  end
end
