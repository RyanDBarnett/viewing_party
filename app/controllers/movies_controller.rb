class MoviesController < ApplicationController
  def index
    block_public_access
    @films = params[:search].present? ? MovieDbFacade.search_films(params[:search]) : MovieDbFacade.discover_films
  end

  def show
    @movie = MovieDbFacade.get_movie_info(params[:id])
  end
end
