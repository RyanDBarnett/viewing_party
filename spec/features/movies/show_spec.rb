require 'rails_helper'

RSpec.describe 'movies show page', type: :feature do
  describe 'as a user' do
    before(:each) do
      # REPLACE THIS WITH WEBMOCK AND STUB
      @movie = Movie.create!(mdb_id: '2')
      @movie_info = MovieDbFacade.get_movie_info(@movie.mdb_id)
      visit movie_path(@movie.id)
    end

    describe "happy path" do
      it "displays movie information from movie API path" do
        expect(page).to have_content(@movie_info.title)
        expect(page).to have_content("Vote Average: #{@movie_info.vote_average}")
        expect(page).to have_content("Genres: Drama, Crime, Comedy")
        expect(page).to have_content("Summary: Taisto Kasurinen is a Finnish coal miner whose father has just committed suicide and who is framed for a crime he did not commit. In jail, he starts to dream about leaving the country and starting a new life. He escapes from prison but things don't go as planned...")
      end

      it 'displays the movie runtime in hours and minutes' do
        expect(page).to have_content("Runtime: #{@movie_info.runtime_hours} Hour(s) #{@movie_info.runtime_minutes} Minute(s)")
      end

      it "displays cast information" do
        expect(page).to have_content('Turo Pajala as Taisto Olavi Kasurinen')
        expect(page).to have_content('Susanna Haavisto as Irmeli Katariina Pihlaja')
        expect(page).to_not have_content('Adam as Professor Etz')
      end

      it 'displays the total reviews count' do
        movie = MovieDbFacade.get_movie_info(3)
        # expected = movie_reviews[:total_results]
        visit movie_path(3)

        expect(page).to have_content("Total Reviews Count: #{movie.review_count}")
      end

      xit "displays review informtion" do
      end
    end
  end
end
