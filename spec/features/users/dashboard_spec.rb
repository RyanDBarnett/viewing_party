require 'rails_helper'

RSpec.describe('Dashboard') do
  describe 'happy path' do
    describe 'as an authenticated user' do
      before :each do
        @user = User.create(name: 'Buffy', email: "buffyslayer@example.com", password: "test")

        visit login_path

        fill_in :email, with: @user.email.upcase
        fill_in :password, with: @user.password

        click_button 'Log In'

        # Logging In Redirects to Dashboard
      end

      it "should display 'Welcome <username>!' at the top of page" do
        expect(page).to have_content("Welcome, #{@user.name}")
      end

      it "should have a button to 'Discover Movies'" do
        expect(page).to have_button('Discover Movies')
      end

      it 'should display all of the users parties', :vcr do
        party1 = Party.create(mdb_id: 10719, start_time: '2021-03-01 01:00:00 UTC')
        viewer1 = Viewer.create(status: 'host', party: party1, user: @user)
        party2 = Party.create(mdb_id: 143569, start_time: '2021-03-02 01:00:00 UTC')
        viewer2 = Viewer.create(status: 'guest', party: party2, user: @user)

        visit dashboard_path

        expect(page).to have_content('My Viewing Parties:')
        expect(page).to have_selector("section[class='viewing-parties']")
        
        within("#party-#{party1.id}") do
          expect(page).to have_content("Elf")
          expect(page).to have_content(party1.start_time)
          expect(page).to have_content(viewer1.status.capitalize)
        end

        within("#party-#{party2.id}") do
          expect(page).to have_content("Elf-Man")
          expect(page).to have_content(party2.start_time)
          expect(page).to have_content(viewer2.status.capitalize)
        end
      end

      it 'should have a friends section' do
        expect(page).to have_content('Friends:')
        expect(page).to have_selector("section[class='friends']")
      end

      describe 'inside the friends section' do
        it "should have a text field to enter a friend's email" do
          within '.friends' do
            expect(page).to have_field("email")
          end
        end

        it "should have a button to 'Add Friend'" do
          within '.friends' do
            expect(page).to have_button('Add Friend')
          end
        end


        describe 'friendship happy path' do
          describe "when I fill in the add friend form with a user's email and click 'Add Friend'" do
            before :each do
              @other_user = User.create(name: 'other', email: "otheruser@example.com", password: "otherpassword")

              within '.friends' do
                fill_in 'email', with: @other_user.email

                click_button 'Add Friend'
              end
            end

            it 'I should be redirected to my dashboard' do
              expect(current_path).to eq(dashboard_path)
            end

            it "I should see my friend's name in my list of friends" do
              within '.friends' do
                expect(page).to have_content(@other_user.name)
              end
            end
          end
        end

        describe 'friendship sad path' do
          describe 'when I fill in the add friend form with an email that does not correspond to a user' do
            it "I should see a notice that says 'Unable to find user with email: <email>'" do
              wrong_email = 'wrong@email.com'

              within '.friends' do
                fill_in 'email', with: wrong_email

                click_button 'Add Friend'
              end

              expect(page).to have_content("Failed Friend Request. Unable to find user with email: #{wrong_email}'")
            end
          end

          describe 'when I fill in the add friend form with my own email' do
            it "I should see a notice that says 'Failed Friend Request. Cannot Friend Yourself.'" do
              within '.friends' do
                fill_in 'email', with: @user.email

                click_button 'Add Friend'
              end

              expect(page).to have_content("Failed Friend Request. Cannot Friend Yourself!")
            end
          end

          describe "when I fill in the add friend form with a previously friended user's email" do
            before :each do
              @other_user = User.create(name: 'other', email: "otheruser@example.com", password: "otherpassword")

              within '.friends' do
                fill_in 'email', with: @other_user.email

                click_button 'Add Friend'
                
                fill_in 'email', with: @other_user.email

                click_button 'Add Friend'
              end
            end

            it "I should see a notice that says 'Failed Friend Request. Already Friended User: <user name>'" do
              expect(page).to have_content("Failed Friend Request. Already Friended User: #{@other_user.name}")
            end
          end
        end

        describe 'if I have not added any friends' do
          it 'there should be a message "You currently have no friends"' do
            within '.friends' do
              expect(page).to have_content('You currently have no friends')
            end
          end
        end
      end

      describe "when a user clicks the 'Discover Movies' button" do
        it 'they should be taken to the discover movies page /discover' do
          click_button 'Discover Movies'

          expect(current_path).to eq(discover_path)
        end
      end
    end
  end

  describe 'sad path' do
    describe 'when I am NOT an authenticated user' do
      before :each do
        visit dashboard_path
      end

      it 'should redirect back to the log in page' do
        expect(current_path).to eq(login_path)
      end

      it "should give a 'You Must Log In To Visit Your Dashboard' notice" do
        expect(page).to have_content('You Must Log In To Visit Your Dashboard')
      end
    end
  end
end
