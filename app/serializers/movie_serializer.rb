class MovieSerializer
  def self.serialize(movies)
    {
      data: movies.map do |movie|
        {
          id: movie[:id].to_s,
          type: 'movie',
          attributes: {
            title: movie[:title],
            vote_average: movie[:vote_average]
          }
        }
      end
    }
  end

  def self.format_movie_details(movie_details, cast, reviews)
    {
      data: {
        id: movie_details[:id].to_s,
        type: "movie",
        attributes: {
          title: movie_details[:title],
          release_year: movie_details[:release_date] ? Date.parse(movie_details[:release_date]).year : nil,
          vote_average: movie_details[:vote_average],
          runtime: format_runtime(movie_details[:runtime]),
          genres: movie_details[:genres],
          summary: movie_details[:overview],
          cast: format_cast(cast),
          total_reviews: reviews.size,
          reviews: format_reviews(reviews)
        }
      }
    }
  end

  private

   def self.format_runtime(runtime_minutes)
      if runtime_minutes.nil?
        nil
      else
        hours = runtime_minutes / 60
        minutes = runtime_minutes % 60
        "#{hours}h #{minutes}m"
      end
   end


  def self.format_cast(cast)
    cast.first(10).map do |member|
      {
        character: member[:character],
        actor: member[:name]
      }
    end
  end

  def self.format_reviews(reviews)
    reviews.first(5).map do |review|
      {
        author: review[:author],
        review: review[:content]
      }
    end
  end
  
end