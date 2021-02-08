class FriendshipsController < ApplicationController
  def create
    friend = User.find_by(email: params[:email])
    notice = if friend
               FriendshipsFacade.add_friendship(current_user, friend)
             else
               "Failed Friend Request. Unable to find user with email: #{params[:email]}'"
             end
    redirect_to dashboard_path, notice: notice
  end
end
