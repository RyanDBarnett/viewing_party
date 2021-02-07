require 'rails_helper'

RSpec.describe Film do
  it 'exists' do
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

    expect(film.title).to eq('The Birds')
    expect(film.vote_average).to eq(8.4)
    expect(film.id).to eq(1)
    expect(film.runtime).to eq(500)
    expect(film.list_genres).to eq('Horror, Historical')
    expect(film.overview).to eq('Damn these birds are mad!')
    expect(film.credits).to eq({cast: [{name: "Turo Pajala", character: "Mary Gifford"}, {name: "Frank Gerry", character: "Bird one"} ]})
  end

  describe 'instance methods' do
    before :each do
      attrs = {
        id: 1,
        title: 'The Birds',
        vote_average: 8.4,
        runtime: 500,
        genres: [{id: 1, name: 'Horror'}, {id: 2, name: 'Historical'}],
        overview: "Damn these birds are mad!",
        credits:  {cast: [{name: "Turo Pajala", character: "Mary Gifford"}, {name: "Frank Gerry", character: "Bird one"} ]}
      }
      @film = Film.new(attrs)
    end
    describe 'cast' do
      it "returns an array where the first element is an array of actor names and the second element is an array of corresponding characters" do
        expect(@film.cast).to eq([["Turo Pajala", "Mary Gifford"], ["Frank Gerry", "Bird one"]])
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
