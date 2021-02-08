class MovieDbFacade
  class << self
    def get_films(params)
      return discover_films unless params[:search].present?

      search_films(params[:search])
    end

    def discover_films
      json = MovieDbService.call_top_films
      create_films(json)
    end

    def search_films(query)
      json = MovieDbService.call_search_films(query)
      create_films(json)
    end

    def get_movie_info(mdb_id)
      json = MovieDbService.call_movie_info(mdb_id)
      @film = Film.new(json)
    end

    private

    def create_films(json)
      json[:results].map do |film_data|
        Film.new(film_data)
      end
    end
  end
end
