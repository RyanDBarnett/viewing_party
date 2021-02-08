require 'rails_helper'

RSpec.describe Film do
  it 'builds a Film object' do
    null = nil
    attrs = {
      id: 1,
      title: 'The Birds',
      vote_average: 8.4,
      runtime: 500,
      genres: [{id: 1, name: 'Horror'}, {id: 2, name: 'Historical'}],
      overview: "Damn these birds are mad!",
      credits:  {cast: [{name: "Turo Pajala", character: "Mary Gifford"}, {name: "Frank Gerry", character: "Bird one"} ]}
    }
    film = Film.new(attrs)

    expect(film).to be_a(Film)
    expect(film).to have_attributes(
      title: 'The Birds',
      vote_average: 8.4,
      id: 1,
      runtime: 500,
      overview: 'Damn these birds are mad!',
      genres: [{id: 1, name: 'Horror'}, {id: 2, name: 'Historical'}],
      credits: {cast: [{name: "Turo Pajala", character: "Mary Gifford"}, {name: "Frank Gerry", character: "Bird one"} ]}
    )
  end

  describe 'instance methods', :vcr do
    before :each do
      @film = MovieDbFacade.get_movie_info(2)
    end

    describe 'cast' do
      it "returns an array where each element is an array where index 0 is the actor name and 1 is the name of the character they play" do
        expect(@film.cast.first).to eq(["Turo Pajala", "Taisto Olavi Kasurinen"])
        expect(@film.cast.last).to eq(["Pekka Wilen", "Skipper"])
        expect(@film.cast.size).to eq(22)
      end
    end

    describe 'first_10_cast' do
      it 'returns the first 10 elements in the films cast array', :vcr do
        expect(@film.first_10_cast.size).to eq(10)
      end

      it 'returns all of the elements if the cast is already less than 10' do
        attrs = {
          id: 1,
          title: 'The Birds',
          vote_average: 8.4,
          runtime: 500,
          genres: [{id: 1, name: 'Horror'}, {id: 2, name: 'Historical'}],
          overview: "Damn these birds are mad!",
          credits:  {cast: [{name: "Turo Pajala", character: "Mary Gifford"}]}
        }

        film = Film.new(attrs)

        expect(film.first_10_cast).to eq([["Turo Pajala", "Mary Gifford"]])
      end
    end

    describe 'list_genres' do
      it "can return list of genres" do
        expect(@film.list_genres).to eq('Drama, Crime, Comedy')
      end
    end

    describe 'runtime_hours' do
      it "returns the number of hours in the film's runtime" do
        expected = (@film.runtime / 60).floor
        expect(@film.runtime_hours).to eq(expected)
      end
    end

    describe 'runtime_minutes' do
      it "returns the number of minutes in the film's runtime" do
        expected = @film.runtime % 60
        expect(@film.runtime_minutes).to eq(expected)
      end
    end
  end
end
