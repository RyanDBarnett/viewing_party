require 'rails_helper'

RSpec.describe "new party page" do
    before(:each) do
        @user = create(:user, email: 'test@email.com')
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    describe "happy path" do
        it "displays movie details and form", :vcr do
            @user = create(:user, email: 'test@email.com')
            allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

            mdb_id = 10719
            visit movie_path(mdb_id)

            click_button('Create a Viewing Party')
                  
            expect(page).to have_content("Create a viewing party for Elf")
            expect(page).to have_css("input[value = '97']")  
        end 

        it "can create new viewing party", :vcr do
            @user = create(:user, email: 'test@email.com')
            allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
            
            mdb_id = 10719
            visit movie_path(mdb_id)
            click_button('Create a Viewing Party')

            fill_in :duration, with: 200
            fill_in :start_time, with: '2021-02-29 01:00:00 UTC'

            click_button 'Submit'

            expect(current_path).to eq(dashboard_path)
            expect(page).to have_content("Yo! You started a party!")
        end


        # sad path puts in date and not time
        # sad path not signed in path
    end
end