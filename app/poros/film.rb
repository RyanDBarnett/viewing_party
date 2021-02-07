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
end
