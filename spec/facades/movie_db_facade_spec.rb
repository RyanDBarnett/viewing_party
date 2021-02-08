require 'rails_helper'

RSpec.describe MovieDbFacade do
  it 'processes data and returns 40 film objects', :vcr do
    films = MovieDbFacade.discover_films

    expect(films.count).to eq(40)
    films.each do |film|
      expect(film).to be_an_instance_of(Film)
    end
  end

  it 'searches for films and returns objects', :vcr do
    films = MovieDbFacade.search_films('Air Bud')

    expect(films.count).to eq(6)
    films.each do |film|
      expect(film).to be_an_instance_of(Film)
    end
  end
end
