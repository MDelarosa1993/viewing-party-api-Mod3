class MovieService
  def self.fetch_top_rated
    conn = Faraday.new(url: "https://api.themoviedb.org/3") do |faraday|
      faraday.params['api_key'] = Rails.application.credentials.movie_api[:key]
    end
    response = conn.get("/3/movie/top_rated")

    json = JSON.parse(response.body, symbolize_names: true)
    MovieSerializer.serialize(json[:results].first(20))
    
  end
end