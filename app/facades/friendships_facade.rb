class FriendshipsFacade
  class << self
    def add_friendship(current_user, friend)
      if friend.id == current_user.id
        'Failed Friend Request. Cannot Friend Yourself!'
      elsif current_user.friends.include?(friend)
        "Failed Friend Request. Already Friended User: #{friend.name}"
      else
        current_user.friendships.create!({ friend_id: friend.id })
      end
    end
  end
end
