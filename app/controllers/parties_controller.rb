class PartiesController < ApplicationController

    def new
        @party = Party.new
    end

    def create
        # params[:party][:mdb_id] = params[movie_id]
        # party[:mdb_id] = params[:id]
        binding.pry
        new_party = Party.new(party_params)
        # if Party.exists?(email: user[:email])
        #   flash[:error`] = "User already exists."
        #   render :new and return
        # end
        if new_party.save
            flash[:success] = "Yo! You started a party!"
            redirect_to dashboard_path
        else
            flash[:error] = "Dun Dun DUUUUN! try again"
            render :new
        end
        
            
    end

    private

    def party_params
      params.require(:party).permit(mdb_id, start_time, duration)
    end
  

end