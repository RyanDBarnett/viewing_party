class MovieService
  class << self
    def call_top_films
      combine(discover(1), discover(2))
    end

    def call_search_films(query)
      combine(search(query, 1), search(query, 2))
    end

    def call_movie_info(mdb_id)
      movie_info(mdb_id)
    end

    private

    def conn
      Faraday.new(
        url: 'https://api.themoviedb.org/3/',
        params: { api_key: ENV['TMDB_API_KEY'] }
      )
    end

    def discover(page)
      response = conn.get('discover/movie') do |req|
        req.params[:sort_by] = 'popularity.desc'
        req.params[:page] = page
      end
      parse_data(response)
    end

    def search(query, page)
      response = conn.get('search/movie') do |req|
        req.params[:query] = query
        req.params[:page] = page
      end
      parse_data(response)
    end

    def movie_info(mdb_id)
      response = conn.get("movie/#{mdb_id}") do |req|
        req.params[:append_to_response] = 'credits,reviews'
      end
      parse_data(response)
    end

    def combine(page_one, page_two)
      return page_one if page_one.is_a? String

      page_one.merge(page_two) { |_key, p1, p2| p1 + p2 }
    end

    def parse_data(response)
      if response.success?
        JSON.parse(response.body, symbolize_names: true)
      else
        'Our movie info provider is having technical difficulties! Please try again later.'
      end
    end
  end
end
