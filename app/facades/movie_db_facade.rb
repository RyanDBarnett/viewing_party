class MovieDbFacade
  class << self
    def get_films(params)
      params[:search].present? ? search_films(params[:search]) : discover_films
    end

    def discover_films
      data = MovieService.call_top_films
      if data.is_a? Hash
        create_films(data)
      else
        data
      end
    end

    def search_films(query)
      data = MovieService.call_search_films(query)
      if data.is_a? Hash
        create_films(data)
      else
        data
      end
    end

    def get_movie_info(mdb_id)
      data = MovieService.call_movie_info(mdb_id)
      if data.is_a? Hash
        @film = Film.new(data)
      else
        data
      end
    end

    private

    def create_films(data)
      data[:results].map do |film_data|
        Film.new(film_data)
      end
    end
  end
end
