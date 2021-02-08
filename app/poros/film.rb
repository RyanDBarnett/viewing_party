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
    @reviews = attributes[:reviews]
  end

  def cast
    credits[:cast].map { |member| [member[:name], member[:character]] }
  end

  def first_10_cast
    cast.first(10)
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
    @reviews[:total_results]
  end

  def reviews
    @reviews[:results]
  end
end
