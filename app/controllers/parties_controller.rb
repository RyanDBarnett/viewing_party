class PartiesController < ApplicationController
  def new
    @party = Party.new
    session[:mdb_id] = params[:movie_id]
    session[:movie_title] = params[:movie]
  end

  def create
    new_party = current_user.parties.new(party_params)

    if new_party.save
      new_party.viewers.create(user: current_user, status: 'host')
      add_guests_to_party(new_party)
      redirect_to(dashboard_path, notice: 'Yo! You started a party!')
    else
      flash[:error] = 'Dun Dun DUUUUN! Try again'
      render :new
    end
  end

  private

  def party_params
    params[:party][:mdb_id] = session[:mdb_id]
    params[:party][:movie_title] = session[:movie_title]
    params.require(:party).permit(:mdb_id, :movie_title, :start_time, :duration)
  end

  def party_viewers
    params[:party][:viewers].reject(&:empty?)
  end

  def add_guests_to_party(party)
    party_viewers.each do |viewer_id|
      party.viewers.create!(user_id: viewer_id, status: 'guest')
    end
  end
end
