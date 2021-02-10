class MoviesController < ApplicationController
  def index
    @films = MovieDbFacade.get_films(params)
  end

  def show
    @movie = MovieDbFacade.get_movie_info(params[:id])
    session[:mdb_id] = params[:id]
    session[:movie_title] = @movie.title
    session[:runtime] = @movie.runtime
  end
end
