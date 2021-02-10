require 'rails_helper'

RSpec.describe Party, :vcr do
  it {should validate_presence_of :start_time}
  it {should validate_presence_of :duration}

  it {should belong_to(:movie)}
  it {should belong_to(:host)}
  it {should have_many(:viewers)}
  it {should have_many(:users).through(:viewers)}
end
