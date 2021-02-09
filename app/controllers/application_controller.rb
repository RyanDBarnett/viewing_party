class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :block_public_access
  helper_method :current_user


  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def block_public_access
    return redirect_to root_path, notice: 'Members only! Sign up or login to access that page.' unless current_user
  end
end
