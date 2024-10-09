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
            viewing_parties_hosted: user.viewing_parties_hosted, # Add this method to the User model
            viewing_parties_invited: user.viewing_parties # Directly gets invited parties
          }
        }
      end
    }
  end
end