require 'rails_helper'

RSpec.describe 'movies index', type: :feature do
  describe 'as a user' do
    describe 'happy path' do
      before(:each) do
        @user = create(:user, email: 'test@email.com')
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      end

      it 'i see 40 movies' do
        visit movies_path

        top_movies = MovieDbFacade.discover_films
        top_movie = top_movies.first
        last_movie = top_movies.last

        expect(page).to have_content("40 Movies")

        within("#movie-#{top_movie.id}") do
          expect(page).to have_link(top_movie.title)
          expect(page).to have_content("Vote Average: #{top_movie.vote_average}")
        end

        within("#movie-#{last_movie.id}") do
          expect(page).to have_link(last_movie.title)
          expect(page).to have_content("Vote Average: #{last_movie.vote_average}")
        end
      end

      it 'i can search by movie title' do
        elf = MovieDbFacade.get_movie_info(10719)
        
        visit movies_path

        within('#movie_search') do
          fill_in :search, with: 'Elf'
          click_button 'Search'
          expect(current_path).to eq(movies_path)
        end

        expect(page).to have_link(elf.title)
        expect(page).to have_content(elf.vote_average)
        expect(page).to_not have_content("Wonder Woman: 1984")
      end
    end

    describe 'sad path' do
      it 'returns top movies if search field is submitted blank' do
        @user = create(:user, email: 'test@email.com')
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        
        visit movies_path

        fill_in :search, with: ''

        expect(current_path).to eq(movies_path)
        expect(page).to have_content('40 Movies')
      end

      it 'returns 0 movies when no matches exist' do
        @user = create(:user, email: 'test@email.com')
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        
        visit movies_path

        fill_in :search, with: 'sdkfjaksdjf'
        click_button 'Search'

        expect(current_path).to eq(movies_path)
        expect(page).to have_content('0 Movies')
      end

      it 'redirects a user that is not signed in to the root path and gives a flash message' do
        visit movies_path
        
        expect(current_path).to eq(root_path)
        expect(page).to have_content('Members only! Sign up or login to access that page.')
      end
    end
  end
end
