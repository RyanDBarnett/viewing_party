class MoviesController < ApplicationController
  def index
    block_public_access
    @films = params[:search].present? ? MovieDbFacade.search_films(params[:search]) : MovieDbFacade.discover_films
  end

  def show
    movie_id = Movie.find_by(id: params[:id]).mdb_id
    @movie = MovieDbFacade.get_movie_info(movie_id)
  end
end
