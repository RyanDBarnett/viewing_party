class MoviesController < ApplicationController
  def index
    @films = MovieDbFacade.get_films(params)
  end

  def show
    @movie = MovieDbFacade.get_movie_info(params[:id])
  end
end
