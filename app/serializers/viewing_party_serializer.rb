class ViewingPartySerializer 
  include JSONAPI::Serializer
  attributes :id, :name, :start_time, :end_time, :movie_id, :movie_title

  attribute :invitees do |viewing_party|
    viewing_party.users.map do |user|
      {
        id: user.id,
        name: user.name,
        username: user.username
      }
    end
  end
end