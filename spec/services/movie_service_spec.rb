require 'rails_helper'

# put helper method in rails hellper
# or use thoughtbot gem to reduce code
# def check_sturcture_data(element, key, value=nil)
#   return false unless element.key? key
#   return false unless element[key].class == type
#   unless value.nil?
#     return false if element[key] != value
#   end
#   true 
# end

RSpec.describe MovieService do
  describe 'class methods' do
    it 'returns top 40 movies', :vcr do
      
      search = MovieService.call_top_films
      # expect(check_structure_data(response, results, Array)).to be_a ...
      expect(search).to be_a Hash
      expect(search).to have_key(:results)
      expect(search[:results]).to be_an Array
      expect(search[:results].size).to eq(40)

      first_film = search[:results].first
      
      expect(first_film).to be_an Hash
      expect(first_film).to have_key :title
      expect(first_film[:title]).to be_a String

      expect(first_film).to have_key :vote_average
      expect(first_film[:vote_average]).to be_a(Numeric)
    end

    it 'returns specific film', :vcr do
      # VCR.use_cassette('movies_show_page/user_visits_movie_show_page')
      mdb_id = 10719
      film = MovieService.call_movie_info(mdb_id)

      expect(film).to be_an Hash
      expect(film).to have_key :title
      expect(film[:title]).to be_a String

      expect(film).to have_key :vote_average
      expect(film[:vote_average]).to be_a(Numeric)
      
      expect(film).to have_key :runtime
      expect(film[:runtime]).to be_a(Numeric)
      
      expect(film).to have_key :genres
      expect(film[:genres]).to be_a(Array)
      
      expect(film).to have_key :overview
      expect(film[:overview]).to be_a(String)
      
      expect(film).to have_key :credits
      expect(film[:credits]).to be_a(Hash)
    end
  end
end
