class MovieDbFacade
  class << self
    def get_films(params)
      return discover_films unless params[:search].present?

      search_films(params[:search])
    end

    def discover_films
      data = MovieService.call_top_films
      create_films(data)
    end

    def search_films(query)
      data = MovieService.call_search_films(query)
      create_films(data)
      # right now returns [] if no films, if we want nil:
      # @films .eahc do
      #  retung Member.do if ... see moc tracker
      # nil
    end

    def get_movie_info(mdb_id)
      data = MovieService.call_movie_info(mdb_id)
      @film = Film.new(data)
    end

    private

    def create_films(data)
      data[:results].map do |film_data|
        Film.new(film_data)
      end
    end
  end
end
