require 'rails_helper'

RSpec.describe MovieDbFacade do
  describe 'happy path' do
    it 'processes movie data and returns 40 Movie objects', :vcr do
      films = MovieDbFacade.discover_films

      expect(films).to be_an(Array)
      expect(films.count).to eq(40)
      expect(films[0]).to be_a(Film)
    end

    it 'processes movie data and searches for films', :vcr do
      query = 'Elf'

      films = MovieDbFacade.search_films(query)

      expect(films).to be_an(Array)
      expect(films[0]).to be_a(Film)
    end
  end
end
