require 'rails_helper'

RSpec.describe Party, :vcr do
  it {should validate_presence_of :start_time}
  it {should validate_presence_of :duration}
  it {should validate_numericality_of(:duration).only_integer}
  it {should validate_numericality_of(:duration).is_greater_than(0)}

  it {should belong_to(:movie)}
  it {should belong_to(:host)}
  it {should have_many(:viewers)}
  it {should have_many(:users).through(:viewers)}

  describe 'instance methods' do
    before :each do
      @user = create(:user, email: 'test@email.com')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      @jerry = create(:user, email: 'jerry@example.com', name: 'jerry', password: "xyz", password_confirmation: "xyz")
      @user.friendships.create!(friend_id: @jerry.id, status: 1)
      @movie = Movie.create!(mdb_id: 775996, title: 'Outside the Wire')
      new_party_data = {
        start_time: 'Mon, 01 Mar 2021 01:00:00 UTC +00:00',
        duration: 200,
        movie: @movie,
        host: @user
      }
      @party = Party.create(new_party_data)
      @party.viewers.create(status: 'host', user: @user)
    end

    describe 'viewer_status' do
      it 'returns the status of the provided viewer id' do
        expect(@party.viewer_status(@user.id)).to eq('Host')
      end
    end

    describe 'strftime' do
      it 'returns the status of the provided viewer id' do
        expect(@party.strftime).to eq('Mar 01, 2021 01:00 AM UTC')
      end
    end
  end
end
