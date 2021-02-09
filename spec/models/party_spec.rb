require 'rails_helper'

RSpec.describe Party, :vcr do
  it {should validate_presence_of :mdb_id}
  it {should validate_presence_of :start_time}
end
