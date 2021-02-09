class UsersController < ApplicationController
  skip_before_action :block_public_access
  
  def new
    @user = User.new
  end

  def create
    user = user_params
    user[:email] = user[:email].downcase
    new_user = User.new(user)
    # if User.exists?(email: user[:email])
    #   flash[:error] = "User already exists."
    #   render :new and return
    # end
    if new_user.save
      session[:user_id] = new_user.id
      flash[:success] = "Welcome, #{current_user.name}"
      redirect_to dashboard_path
    else
      flash[:error] = 'Your credentials need soem work bruh'
      redirect_to new_user_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
