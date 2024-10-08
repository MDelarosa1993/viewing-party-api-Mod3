require 'rails_helper'

RSpec.describe ViewingParty, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:end_time) }
  it { should validate_presence_of(:movie_id) }
  it { should validate_presence_of(:movie_title) }
  it { should belong_to(:host) }
  it { should have_many(:viewing_party_users) }
  it { should have_many(:users).through(:viewing_party_users) }
end