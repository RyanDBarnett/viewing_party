require 'rails_helper'
RSpec.describe 'movies show page', type: :feature do
  describe "happy path", :vcr do
    # HOW DO WE USE ONE VCR CASSETTE FOR ALL TESTS? VCR.use_cassette aint workin
    before(:each) do
      @user = create(:user, email: 'test@email.com')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      mdb_id = 10719
      visit movie_path(mdb_id)
    end
    it "user visits movie show page" do
      expect(page).to have_content('Elf')
      expect(page).to have_content('Vote Average: 6.6')
      expect(page).to have_content("Runtime: 1 Hour(s) 37 Minute(s)")
      expect(page).to have_content("Genres: Comedy, Family, Fantasy")
      expect(page).to have_content("When young Buddy falls into Santa's gift sack on Christmas Eve, he's transported back to the North Pole and raised as a toy-making elf by Santa's helpers. But as he grows into adulthood, he can't shake the nagging feeling that he doesn't belong. Buddy vows to visit Manhattan and find his real dad, a workaholic publisher.")
      expect(page).to have_content('Will Ferrell as Buddy')
      expect(page).to have_content('Zooey Deschanel as Jovie')
      expect(page).to_not have_content('Adam as Professor Etz')
    end
    it 'displays the total reviews count' do
      expect(page).to have_content("Total Reviews Count: 3")
    end
    it 'only displays the first 10 cast members' do
      within '#cast' do
        expect(page.all(:css, '.cast-member').size).to eq(10)
      end
    end
    it 'it displays the review author and rating', :vcr do
      within '#reviews' do
        expect(page.all(:css, '.review').size).to eq(3)
        expect(page).to have_content("Author: Peter M")
        expect(page).to have_content("Rating: 9.0")
      end
    end
    it "displays a link to create a new party" do
      expect(page).to have_button('Create a Viewing Party')
      click_on 'Create a Viewing Party'
      expect(current_path).to eq(new_party_path)
    end

    it 'displays an error message if API request fails', :vcr do
      stub_request(:get, "https://api.themoviedb.org/3/movie/10719?api_key=#{ENV['TMDB_API_KEY']}&append_to_response=credits,reviews").
        to_return(status: 500, body: "")
      
      visit movie_path(10719)
      
      expect(page).to have_content('Our movie info provider is having technical difficulties! Please try again later.')
    end
  end
end
