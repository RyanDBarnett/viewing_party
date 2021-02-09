require 'rails_helper'

RSpec.describe "new party page" do
    describe "happy path" do
        it "displays movie details and form", :vcr do
            mdb_id = 10719
            visit movie_path(mdb_id)

            click_button('Create a Viewing Party')
                  
            # expect(current_path).to eq(new_user_path)
            expect(page).to have_content("Create a viewing party for Elf")
        end
    end
end