class Film
  attr_reader :id,
              :title,
              :vote_average,
              :runtime,
              :genres,
              :overview,
              :credits

  def initialize(attributes)
    @id = attributes[:id]
    @title = attributes[:title]
    @vote_average = attributes[:vote_average]
    @runtime = attributes[:runtime]
    @genres = attributes[:genres]
    @overview = attributes[:overview]
    @credits = attributes[:credits]
  end

  def cast
    credits[:cast].map { |member| [member[:name], member[:character]] }
  end

  def list_genres
    genres.map { |genre| genre[:name] }.join(', ')
  end

  def runtime_hours
    (@runtime / 60).floor
  end

  def runtime_minutes
    @runtime % 60
  end

  def review_count
    MovieDbFacade.get_movie_reviews(id)[:total_results]
  end
end
