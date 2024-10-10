class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :username, :api_key

   def self.format_user_list(users)
      {
        data: users.map do |user|
          {
            id: user.id.to_s,
            type: "user",
            attributes: {
              name: user.name,
              username: user.username,
              viewing_parties_hosted: user.viewing_parties_hosted.map do |party|
                {
                  id: party.id,
                  name: party.name,
                  start_time: party.start_time,
                  end_time: party.end_time,
                  movie_id: party.movie_id,
                  movie_title: party.movie_title,
                  host_id: party.host_id 
               }
              end,
              viewing_parties_invited: user.viewing_parties_invited.map do |party|
                {
                  id: party.id,
                  name: party.name,
                  start_time: party.start_time,
                  end_time: party.end_time,
                  movie_id: party.movie_id,
                  movie_title: party.movie_title,
                  host_id: party.host_id 
                }
              end
            }
          }
        end
      }
   end
end