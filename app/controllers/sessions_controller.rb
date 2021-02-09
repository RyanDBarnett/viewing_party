class SessionsController < ApplicationController
  skip_before_action :block_public_access
  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      reset_session
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}"
      redirect_to dashboard_path
    else
      flash[:error] = 'Your credentials are bad, and you should feel bad'
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'Log Out Successful'
  end
end
