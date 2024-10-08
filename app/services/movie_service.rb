class MovieService
  def self.fetch_top_rated
    conn = Faraday.new(url: "https://api.themoviedb.org/3") do |faraday|
      faraday.params['api_key'] = Rails.application.credentials.movie_api[:key]
    end
    response = conn.get("/3/movie/top_rated")
    json = JSON.parse(response.body, symbolize_names: true)
    MovieSerializer.serialize(json[:results].first(20))
  end

  def self.search_by_name(query)
    conn = Faraday.new(url: "https://api.themoviedb.org/3") do |faraday|
      faraday.params['api_key'] = Rails.application.credentials.movie_api[:key]
    end
     response = conn.get("/3/search/movie") do |req|
      req.params['query'] = query
    end
    json = JSON.parse(response.body, symbolize_names: true)
    MovieSerializer.serialize(json[:results].first(20))
  end

  def self.get_movie_details(movie_id)
    conn = Faraday.new(url: "https://api.themoviedb.org/3") do |faraday|
      faraday.params['api_key'] = Rails.application.credentials.movie_api[:key]
    end
    response = conn.get("/3/movie/#{movie_id}", { append_to_response: 'credits,reviews' })
    json = JSON.parse(response.body, symbolize_names: true)
     
    movie_details = json
    cast = json.dig(:credits, :cast) #credits is the object and cast is the array in the movie api
    reviews = json.dig(:reviews, :results)  #reviews is the object and results is the array in the movie api
    MovieSerializer.format_movie_details(movie_details, cast, reviews)
  end
end