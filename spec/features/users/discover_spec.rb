require 'rails_helper'

RSpec.describe 'user can discover movies', type: :feature do
  describe 'as a user' do
    describe 'happy path' do
      before(:each) do
        @user = create(:user, email: 'test@email.com')
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      end

      it 'i see a button to discover top 40 movies and it takes me to movies index', :vcr do
        visit discover_path

        expect(page).to have_button("Discover Top 40 Movies")
        
        click_button "Discover Top 40 Movies"

        expect(current_path).to eq(movies_path)
      end

      it 'i can see a button to search for movies', :vcr do
        visit discover_path

        within('#movie_search') do
          fill_in :search, with: 'Independence Day'
          click_button 'Search'
        end
        
        expect(current_path).to eq(movies_path)

        expect(page).to have_content("Independence Day")
        expect(page).to have_content("Vote Average: 6.8")
        expect(page).to_not have_content("Wonder Woman: 1984")
      end
    end

    describe 'sad path' do
      it 'non-users are redirected to rooth path and shown a flash message when they attempt to access discover page' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        visit discover_path

        expect(current_path).to eq(root_path)
        expect(page).to have_content("Members only! Sign up or login to access that page.")
      end
    end
  end
end
