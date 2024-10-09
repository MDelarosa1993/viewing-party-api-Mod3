require 'rails_helper'

RSpec.describe "ViewingParty", type: :request do 
  describe "Create viewing party" do 
    it 'creates a viewing party with all the neccessary attributes' do
      user = User.create!(name: "Danny DeVito", username: "danny_de_v", api_key: "e1An2gAidDbWtJuhbHFKryjU", password: "jerseyMikesRox7")
      invitee1 = User.create(name: "Hannah", username: "ha_merc", password: "mercado1234")
      invitee2 = User.create(name: "Sabrina", username: "sa_dela", password: "delarosa123")
      invitee3 = User.create(name: "Aldo", username: "al_merc", password: "al_mercado1234")
      party_params = {
        "name": "Juliet's Bday Movie Bash!",
        "start_time": "2025-02-01 10:00:00",
        "end_time": "2025-02-01 14:30:00",
        "movie_id": 278,
        "movie_title": "The Shawshank Redemption",
        "api_key": user.api_key, 
        "invitees": [invitee1.id, invitee2.id, invitee3.id] 
      }
      post "/api/v1/viewing_parties",  params: party_params 
      
      expect(response).to be_successful

      new_party = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
      
      expect(new_party[:end_time]).to be_a(String)
      expect(new_party[:id]).to be_a(Integer)
      expect(new_party).to have_key(:invitees)
      expect(new_party[:invitees]).to be_an(Array)

      new_party[:invitees].each do |invitee|
        expect(invitee).to have_key(:id)
        expect(invitee[:id]).to be_an(Integer)
        expect(invitee).to have_key(:name)
        expect(invitee[:name]).to be_a(String)
        expect(invitee).to have_key(:username)
      end
    end
  end
end