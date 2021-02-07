require 'rails_helper'

RSpec.describe MovieDbFacade do
  it 'processes movie data and returns 40 Movie objects', :vcr do
    films = MovieDbFacade.discover_films

    expect(films.count).to eq(40)
    films.each do |film|
      expect(film).to be_an_instance_of(Film)
    end
  end
end
