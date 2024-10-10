require 'rails_helper'

RSpec.describe "Api::V1::Movies", type: :request do
  describe "Get/top_rated" do
    it "retrieves the most top_rated movies" do
      json_response = File.read("spec/fixtures/top_rated_movies.json")
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated")
        .with(query: { api_key: Rails.application.credentials.movie_api[:key] })
        .to_return(status: 200, body: json_response)
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

  describe 'Get/search' do 
    it 'retrieves movie by name' do
       json_response = File.read("spec/fixtures/movie_search.json")
      stub_request(:get, "https://api.themoviedb.org/3/search/movie")
        .with(query: { query: "Jack Reacher", api_key: Rails.application.credentials.movie_api[:key] })
        .to_return(status: 200, body: json_response)

      get "/api/v1/movies/search", params: { query: "Jack Reacher" } 
      
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

  describe 'Get/movie_details' do 
     it 'retrieves movie details by id, adds cast and reviews' do 
      movie_id = 278
      json_response = File.read("spec/fixtures/movie_credits_reviews.json")  
       stub_request(:get, "https://api.themoviedb.org/3/movie/#{movie_id}")
        .with(query: { api_key: Rails.application.credentials.movie_api[:key], append_to_response: 'credits,reviews' })
        .to_return(status: 200, body: json_response)
     

      get "/api/v1/movies/#{movie_id}"

      expect(response).to be_successful

      movie_details = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
      
      expect(movie_details[:title]).to be_a(String)
      expect(movie_details[:release_year]).to be_a(Integer)
      expect(movie_details[:vote_average]).to be_a(Float)
      expect(movie_details[:runtime]).to be_a(String)
      expect(movie_details[:summary]).to be_a(String)
      expect(movie_details[:genres]).to be_an(Array)

      # Validate the cast details
      expect(movie_details[:cast]).to be_an(Array)
      movie_details[:cast].each do |member|
        expect(member).to include(:character, :actor)
        expect(member[:character]).to be_a(String)
        expect(member[:actor]).to be_a(String)
      end

      # Validate the reviews details
      expect(movie_details[:reviews]).to be_an(Array)
      movie_details[:reviews].each do |review|
        expect(review).to include(:author, :review)
        expect(review[:author]).to be_a(String)
        expect(review[:review]).to be_a(String)
      end
    end
  end
end

