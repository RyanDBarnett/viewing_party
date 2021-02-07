require 'rails_helper'

RSpec.describe MovieDbService do
  describe 'class methods' do
    it 'returns top 40 movies', :vcr do
      
      search = MovieDbService.call_top_films

      expect(search).to be_a Hash
      expect(search[:results]).to be_an Array
      expect(search[:results].size).to eq(40)

      movie_data = search[:results].first
      
      expect(movie_data).to have_key :title
      expect(movie_data[:title]).to be_a String

      expect(movie_data).to have_key :vote_average
      expect(movie_data[:vote_average]).to be_a(Integer).or be_a(Float)

      movie_data = search[:results].second
      
      expect(movie_data).to have_key :title
      expect(movie_data[:title]).to be_a String

      expect(movie_data).to have_key :vote_average
      expect(movie_data[:vote_average]).to be_a(Integer).or be_a(Float)
    end
  end
end
