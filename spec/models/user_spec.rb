require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:password) }
    it { should have_secure_password }
    it { should have_secure_token(:api_key) }
  end

  describe '#instance_methods' do 
    it 'gets the parties it hosted' do
      user = User.create!(name: "Danny DeVito", username: "danny_de_v", password: "jerseyMikesRox7")
      party1 = ViewingParty.create!(name: "Party 1", start_time: "2025-02-01 10:00:00", end_time: "2025-02-01 14:30:00", movie_id: 1, movie_title: "Movie 1", host_id: user.id)
      party2 = ViewingParty.create!(name: "Party 2", start_time: "2025-02-02 10:00:00", end_time: "2025-02-02 14:30:00", movie_id: 2, movie_title: "Movie 2", host_id: user.id)
      other_user = User.create!(name: "Other User", username: "other_user", password: "password")
      party3 = ViewingParty.create!(name: "Other Party", start_time: "2025-03-01 10:00:00", end_time: "2025-03-01 14:30:00", movie_id: 3, movie_title: "Movie 3", host_id: other_user.id)

      expect(user.viewing_parties_hosted).to eq([party1, party2])
      expect(user.viewing_parties_hosted).not_to eq(party3)
    end
  end
end