require 'rails_helper'

RSpec.describe MovieDbFacade do
  describe 'happy path' do
    it 'discovers top 40 films', :vcr do
      films = MovieDbFacade.discover_films

      expect(films).to be_an(Array)
      expect(films.count).to eq(40)
      expect(films[0]).to be_a(Film)
    end

    it 'searches for films' do
      VCR.use_cassette("MovieDbFacade/happy_path/searches_for_films") do
        query = 'Elf'
        film_search = MovieDbFacade.search_films(query)
        expect(film_search).to be_an(Array)
        expect(film_search[0]).to be_a(Film)
      end
    end
    
    it 'gets film data', :vcr do
      mdb_id = 10719
      film = MovieDbFacade.get_movie_info(mdb_id)
      expect(film).to be_a(Film)
    end
  end

  describe 'sad path' do
    it 'returns nil if no match is found in search', :vcr do
      query = 'Asgjhhs hs68'
      film_search = MovieDbFacade.search_films(query)

      expect(film_search).to eq([])
    end
  end
end
