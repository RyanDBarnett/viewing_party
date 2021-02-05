class MoviesController < ApplicationController
  def index
    block_public_access
    if params[:search].present?
      @films = MovieDbFacade.search_films(params[:search])
    else
      @films = MovieDbFacade.discover_films
    end
  end
end
