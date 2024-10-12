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

  describe '#class_methods' do 
    it 'creates a viewing party with valid invitees' do 
      host = User.create!(name: "Danny DeVito", username: "danny_de_v", password: "jerseyMikesRox7")
      invitee1 = User.create!(name: "Hannah", username: "ha_merc", password: "mercado1234")
      invitee2 = User.create!(name: "Sabrina", username: "sa_dela", password: "delarosa123")

      party_params = {
        name: "Movie Night",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 1,
        movie_title: "Movie Title",
        invitees: [invitee1.id, invitee2.id]
      }
      movie_runtime = "2h 0m"

      viewing_party = ViewingParty.create_with_invitees(party_params, host, movie_runtime)

      expect(viewing_party).to be_present
      expect(viewing_party.host).to eq(host)
      expect(viewing_party.users).to include(invitee1, invitee2)
    end

    it 'returns nil if the viewing party fails to save' do
      host = User.create!(name: "Danny DeVito", username: "danny_de_v", password: "jerseyMikesRox7")

      party_params = {
        name: "",  
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 1,
        movie_title: "Movie Title"
      }

      movie_runtime = "2h 0m"

      viewing_party = ViewingParty.create_with_invitees(party_params, host, movie_runtime)

      expect(viewing_party).to be_nil
    end
  end

  describe '#long_enough?' do
      it 'returns true if the party duration is long enough for the movie' do
        party = ViewingParty.new(
          start_time: Time.now,
          end_time: Time.now + 3.hours, 
          movie_id: 1,
          movie_title: "Movie Title"
        )

        expect(party.long_enough?(120)).to be(true) 
      end

      it 'returns false if the party duration is not long enough for the movie' do
        party = ViewingParty.new(
          start_time: Time.now,
          end_time: Time.now + 1.hour, 
          movie_id: 1,
          movie_title: "Movie Title"
        )

        expect(party.long_enough?(120)).to be(false) 
      end
    end

    describe '.convert_runtime_to_minutes' do
      it 'converts a runtime string in "xh ym" format to minutes' do
        expect(ViewingParty.convert_runtime_to_minutes("2h 30m")).to eq(150)
      end

      it 'converts a runtime string with only hours to minutes' do
        expect(ViewingParty.convert_runtime_to_minutes("2h")).to eq(120)
      end

      it 'converts a runtime string with only minutes to minutes' do
        expect(ViewingParty.convert_runtime_to_minutes("45m")).to eq(45)
      end

      it 'returns 0 for an empty runtime string' do
        expect(ViewingParty.convert_runtime_to_minutes("")).to eq(0)
      end

      it 'returns 0 if the format is incorrect' do
        expect(ViewingParty.convert_runtime_to_minutes("invalid format")).to eq(0)
      end
    end
end