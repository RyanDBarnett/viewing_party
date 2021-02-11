require 'rails_helper'

RSpec.describe 'movies index', type: :feature do
  describe 'as a user' do
    before(:each) do
      @user = create(:user, email: 'test@email.com')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    describe 'happy path' do  
      it 'lists 40 most highest rated movies' do
        VCR.insert_cassette("spec/fixtures/vcr_cassettes/happy_path/discovers_top_40_films")

        visit movies_path

        expect(page).to have_content("Discover Movies")

        expect(page).to have_css(".movie", count: 40)

        within(first('.movie')) do
          expect(page).to have_css(".title")
          expect(page).to have_css(".vote_avg")    
        end
        VCR.eject_cassette("spec/fixtures/vcr_cassettes/happy_path/discovers_top_40_films")
      end

      it 'i can search by movie title' do
        VCR.insert_cassette("spec/fixtures/vcr_cassettes/happy_path/searches_for_films")

        visit movies_path

        # MAYBE CHANGE TO CLASS . SO WE CAN FORMAT EVERY SEARCH BAR THE SAME WAY
        within('#movie_search') do
          fill_in :search, with: 'Elf'
          click_button 'Search'
          expect(current_path).to eq(movies_path)
        end

        expect(page).to have_content('Elf')
        expect(page).to have_content('6.6')
        expect(page).to_not have_content("Wonder Woman: 1984")
        VCR.eject_cassette("spec/fixtures/vcr_cassettes/happy_path/searches_for_films")
      end
    end

    describe 'sad path' do
      it 'returns top movies if search field is submitted blank' do 
        # ASK INSTRUCTOR WHY THIS FEELS WRONG.
        VCR.insert_cassette("spec/fixtures/vcr_cassettes/happy_path/discovers_top_40_films")
       
        visit movies_path

        fill_in :search, with: ''

        expect(current_path).to eq(movies_path)
        expect(page).to have_css(".movie", count: 40)
      end

      it 'returns 0 movies when no matches exist', :vcr do        
        VCR.insert_cassette("spec/fixtures/vcr_cassettes/sad_path/returns_nil_if_no_match_is_found_in_search")
        visit movies_path

        fill_in :search, with: 'sdkfjaksdjf'
        click_button 'Search'

        expect(current_path).to eq(movies_path)
        expect(page).to have_css(".movie", count: 0)
      end

      it 'redirects a user that is not signed in to the root path and gives a flash message', :vcr do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
        visit movies_path
        
        expect(current_path).to eq(root_path)
        expect(page).to have_content('Members only! Sign up or login to access that page.')
      end
      
      it 'returns an error message if the API fails to return movie data', :vcr do
        stub_request(:get, 'https://api.themoviedb.org/3/discover/movie?api_key=e39822378fcaf2d82d455da242fd3002&page=1&sort_by=popularity.desc').
          to_return(status: 500, body: "")

        stub_request(:get, 'https://api.themoviedb.org/3/search/movie?api_key=e39822378fcaf2d82d455da242fd3002&page=1&query=Elf').
          to_return(status: 500, body: "")

        stub_request(:get, 'https://api.themoviedb.org/3/movie/2?api_key=e39822378fcaf2d82d455da242fd3002&append_to_response=credits,reviews').
          to_return(status: 500, body: "")

        expect(MovieDbFacade.discover_films).to eq('Our movie info provider is having technical difficulties! Please try again later.')
        expect(MovieDbFacade.search_films('Elf')).to eq('Our movie info provider is having technical difficulties! Please try again later.')
        expect(MovieDbFacade.get_movie_info(2)).to eq('Our movie info provider is having technical difficulties! Please try again later.')
        
        visit movies_path

        expect(page).to have_content('Our movie info provider is having technical difficulties! Please try again later.')
      end
    end
  end
end
