class MoviesController < ApplicationController
  def index
    block_public_access
    @films = if params[:search].present?
               MovieDbFacade.search_films(params[:search])
             else
               MovieDbFacade.discover_films
             end
  end

  def show
    @movie = MovieDbFacade.get_movie_info(params[:id])
  end
end
