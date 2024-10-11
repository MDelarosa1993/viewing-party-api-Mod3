require 'rails_helper'

RSpec.describe "ViewingParty", type: :request do 
  describe 'get all viewing parties' do
    User.destroy_all
    ViewingParty.destroy_all
    it 'retrieves all the viewing parties' do
      user = User.create!(name: "Danny DeVito", username: "danny_de_v", password: "jerseyMikesRox7")
      ViewingParty.create!("name": "Dannnys Bday Movie Bash!",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 278,
        movie_title: "The Shawshank Redemption",
        host_id: user.id )
      ViewingParty.create!("name": "Mels Bday Movie Bash!",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 275,
        movie_title: "Gladiator",
        host_id: user.id )

      get '/api/v1/viewing_parties'

      expect(response).to be_successful

      all_parties = JSON.parse(response.body, symbolize_names: true)[:data]
      
      all_parties.each do |party|
        expect(party[:id]).to be_a(String)
        expect(party[:type]).to be_a(String)
        expect(party).to have_key(:attributes)
        expect(party[:attributes][:id]).to be_an(Integer)
        expect(party[:attributes][:name]).to be_an(String)
        expect(party[:attributes][:start_time]).to be_an(String)
        expect(party[:attributes][:end_time]).to be_an(String)
        expect(party[:attributes][:movie_id]).to be_an(Integer)
        expect(party[:attributes][:movie_title]).to be_an(String)
        expect(party[:attributes][:invitees]).to be_an(Array)
      end
    end
  end
  describe "Create viewing party" do 
    it 'creates a viewing party with all the neccessary attributes', :vcr do
      ViewingParty.destroy_all
      User.destroy_all
      # require 'pry'; binding.pry
      user = User.create!(name: "Danny DeVito", username: "danny_de_v", password_digest: "e1An2gAidDbWtJuhbHFKryjU", password: "jerseyMikesRox7")
      invitee1 = User.create(name: "Hannah", username: "ha_merc", password: "mercado1234")
      invitee2 = User.create(name: "Sabrina", username: "sa_dela", password: "delarosa123")
      invitee3 = User.create(name: "Aldo", username: "al_merc", password: "al_mercado1234")
      party_params = {
        name: "Juliet's Bday Movie Bash!",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 278,
        movie_title: "The Shawshank Redemption",
        api_key: user.api_key, 
        invitees: [invitee1.id, invitee2.id, invitee3.id] 
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
    
    it 'adds a user to a viewing party' do 
      ViewingParty.destroy_all
      User.destroy_all
      user = User.create!(name: "Danny DeVito", username: "danny_de_v", password: "jerseyMikesRox7")
      invitee1 = User.create(name: "Hannah", username: "ha_merc", password: "mercado1234")
      invitee2 = User.create(name: "Sabrina", username: "sa_dela", password: "delarosa123")
      invitee3 = User.create(name: "Aldo", username: "al_merc", password: "al_mercado1234")

      old_vp = ViewingParty.create!("name": "Dannnys Bday Movie Bash!",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 278,
        movie_title: "The Shawshank Redemption",
        host_id: user.id )

        ViewingPartyUser.create!(viewing_party: old_vp, user: invitee1)
        ViewingPartyUser.create!(viewing_party: old_vp, user: invitee2)
        ViewingPartyUser.create!(viewing_party: old_vp, user: invitee3)
        

      new_invitee = User.create(name: "Alonnah", username: "al_dela", password: "delarosa1234")
      
      add_invitee_params = { api_key: user.api_key, invitee_user_id: new_invitee.id }

      patch "/api/v1/viewing_parties/#{old_vp.id}", params: add_invitee_params

      expect(response).to be_successful

      new_vp = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
      

      expect(new_vp[:id]).to be_an(Integer)
      expect(new_vp[:name]).to be_a(String)
      expect(new_vp[:start_time]).to be_a(String)
      expect(new_vp[:end_time]).to be_a(String)
      expect(new_vp[:movie_id]).to be_an(Integer)
      expect(new_vp[:movie_title]).to be_a(String)
      expect(new_vp).to have_key(:invitees)
      new_vp[:invitees].each do |invitee|
        expect(invitee[:id]).to be_an(Integer)
        expect(invitee[:name]).to be_a(String)
        expect(invitee[:username]).to be_a(String)
      end
    end
  end

  describe 'sad_paths' do 
    it "returns an unauthorized error" do
        post "/api/v1/viewing_parties", params: {
          name: "Movie Night",
          start_time: "2025-02-01 10:00:00",
          end_time: "2025-02-01 14:30:00",
          movie_id: 1,
          movie_title: "Movie Title",
          invitees: []
        }

        expect(response).to have_http_status(:unauthorized)
      
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:message]).to eq('Invalid API key')
        expect(json_response[:status]).to eq("unauthorized")
      end

    it "returns an error for missing attributes" do
      user = User.create!(name: "Test User", username: "test_user", password: "password", api_key: "valid_api_key")
      post "/api/v1/viewing_parties", params: {
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        api_key: user.api_key 
      }

      expect(response).to have_http_status(:unprocessable_entity) 
      json_response = JSON.parse(response.body, symbolize_names: true)
      
      expect(json_response[:message]).to be_an(Array)
      expect(json_response[:status]).to be_a(String)
    end
  end
end