require 'rails_helper'

RSpec.describe User do
  describe 'Validations' do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :password }
    it { should validate_presence_of :name }

    it {should have_many(:friendships)}
    it {should have_many(:friends).through(:friendships)}
    it {should have_many(:viewers)}
    it {should have_many(:parties).through(:viewers)}
  end

  describe 'instance methods' do
    describe 'all_friends' do
      it 'returns friends and inverse friends' do
        @user = create(:user, email: 'test@email.com')
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        @jerry = create(:user, email: 'jerry@example.com', name: 'jerry', password: "xyz", password_confirmation: "xyz")
        @user.friendships.create!(friend_id: @jerry.id, status: 1)

        expect(@jerry.all_friends).to eq([@user])
      end
    end

    describe 'host_parties' do
      it 'returns an array of all the parties hosted' do
        @user = create(:user, email: 'test@email.com')
        user2 = User.create(name: 'Mr. Mojo', email: "mrmojo@example.com", password: "test")
        Friendship.create(user: @user, friend: user2, status: 'accepted')
        movie1 = Movie.create(mdb_id: 10719, title: 'Elf')
        movie2 = Movie.create(mdb_id: 143569, title: 'Elf-man')
        party1 = Party.create!(movie: movie1, host: @user, start_time: '2021-03-01 01:00:00 UTC', duration: 200)
        viewer1 = party1.viewers.create!(status: 'host', party: party1, user: @user)
        party2 = Party.create!(movie: movie2, host: user2, start_time: '2021-03-02 01:00:00 UTC', duration: 205)
        viewer2 = party2.viewers.create!(status: 'host', party: party2, user: user2)
        viewer3 = party2.viewers.create!(status: 'guest', party: party2, user: @user)

        expect(@user.host_parties).to eq([party1])
      end
    end

    describe 'guest_parties' do
      it 'returns an array of all the parties invited to' do
        @user = create(:user, email: 'test@email.com')
        user2 = User.create(name: 'Mr. Mojo', email: "mrmojo@example.com", password: "test")
        Friendship.create(user: @user, friend: user2, status: 'accepted')
        movie1 = Movie.create(mdb_id: 10719, title: 'Elf')
        movie2 = Movie.create(mdb_id: 143569, title: 'Elf-man')
        party1 = Party.create!(movie: movie1, host: @user, start_time: '2021-03-01 01:00:00 UTC', duration: 200)
        viewer1 = party1.viewers.create!(status: 'host', party: party1, user: @user)
        party2 = Party.create!(movie: movie2, host: user2, start_time: '2021-03-02 01:00:00 UTC', duration: 205)
        viewer2 = party2.viewers.create!(status: 'host', party: party2, user: user2)
        viewer3 = party2.viewers.create!(status: 'guest', party: party2, user: @user)

        expect(@user.guest_parties).to eq([party2])
      end
    end
  end
end
