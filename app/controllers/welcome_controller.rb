class WelcomeController < ApplicationController
  skip_before_action :block_public_access
  
  def index
    redirect_to dashboard_path if current_user
  end
end
