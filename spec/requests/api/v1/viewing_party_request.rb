require 'rails_helper'

RSpec.describe "ViewingParty", type: :request do 
  describe "Create viewing party" do 
    it 'creates a viewing party with all the neccessary attributes' do
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
end