require 'rails_helper'

RSpec.describe 'movies show page', type: :feature do
    describe 'as a user' do
        describe "happy path" do
            it "user visits movie show page", :vcr do
                visit movie_path(2)
                expect(page).to have_content('Ariel')
                expect(page).to have_content('Vote Average: 6.8')
                expect(page).to have_content("Runtime: 1 Hour(s) 13 Minute(s)")
                expect(page).to have_content("Genres: Drama, Crime, Comedy")
                expect(page).to have_content("Taisto Kasurinen is a Finnish coal miner whose father has just committed suicide and who is framed for a crime he did not commit. In jail, he starts to dream about leaving the country and starting a new life. He escapes from prison but things don't go as planned...")
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
        end
    end
end
