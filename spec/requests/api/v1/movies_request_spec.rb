require 'rails_helper'

RSpec.describe "Api::V1::Movies", type: :request do
  describe "Get/top_rated" do
    it "retrieves the most top_rated movies" do
      get "/api/v1/movies/top_rated"
      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      
      expect(json).to have_key(:data)
      expect(json[:data]).to be_an(Array)
      json[:data].each do |movie|
        expect(movie).to have_key(:id)
        expect(movie).to have_key(:type)
        expect(movie).to have_key(:attributes)

        attributes = movie[:attributes]
        expect(attributes).to have_key(:title)
        expect(attributes).to have_key(:vote_average)

        expect(movie[:id]).to be_a(String)
        expect(movie[:type]).to eq("movie")
        expect(attributes[:title]).to be_a(String)
        expect(attributes[:vote_average]).to be_a(Float)
      end
    end
  end
end

