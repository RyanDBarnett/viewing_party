class PartiesController < ApplicationController
    def new
        @party = Party.new
    end

    def create
        new_party = current_user.parties.new(party_params)
        if new_party.save
            new_party.viewers.create(user: current_user, status: 'host')
            party_viewers_params.each do |friend_id|
                unless friend_id.blank?
                    new_party.viewers.create(
                        user_id: friend_id,
                        status: 'guest')
                end
            end
            redirect_to dashboard_path, notice: 'Yo! You started a party!'
        else
            flash[:error] = "Dun Dun DUUUUN! try again"
            render :new
        end
    end

    private

    def party_params
        params.require(:party).permit(:mdb_id, :movie_title, :start_time, :duration)
    end

    def party_viewers_params
        params.require(:party).permit(:viewers)
    end
end
