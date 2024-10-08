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
end