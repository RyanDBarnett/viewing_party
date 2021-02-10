class PartiesController < ApplicationController
    def new
        @party = Party.new
    end

    def create
        movie = Movie.create(mdb_id: session[:mdb_id], title: session[:movie_title])
        party = party_params
        party[:host] = current_user
        party[:movie] = movie
        new_party = current_user.parties.new(party)
        if new_party.save
            new_party.viewers.create(user: current_user, status: 'host')
            party_viewers.each do |friend_id|
                new_party.viewers.create!(user_id: friend_id, status: 'guest')
            end
            redirect_to dashboard_path, notice: 'Yo! You started a party!'
        else
            flash[:error] = "Dun Dun DUUUUN! Try again"
            render :new
        end
    end

    private

    def party_params
        params[:party][:movie] = session[:mdb_id]
        params[:party][:host] = current_user
        params.require(:party).permit(:movie, :host, :start_time, :duration)
    end

    def party_viewers
        params[:party][:viewers].reject(&:empty?)
    end
end
