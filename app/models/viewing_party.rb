class ViewingParty < ApplicationRecord
  belongs_to :host, class_name: 'User'
  has_many :viewing_party_users
  has_many :users, through: :viewing_party_users

  validates :name, :start_time, :end_time, :movie_id, :movie_title, presence: true

  def self.create_with_invitees(party_params, host, movie_runtime)
    viewing_party = new(party_params.except(:invitees))
    viewing_party.host = host
    movie_runtime_minutes = convert_runtime_to_minutes(movie_runtime)

    invitee_ids = party_params[:invitees] || []
    if !viewing_party.long_enough?(movie_runtime_minutes)
      return nil, "Party duration is too short for this movie."
    end
    if viewing_party.save
      invitee_ids.each do |invitee_id|
        user = User.find_by(id: invitee_id)
        viewing_party.users << user if user
      end
      return viewing_party
    else
      return nil
    end
  end



  def long_enough?(movie_runtime)
    party_duration = ((end_time - start_time) / 60).to_i
    party_duration >= movie_runtime.to_i
  end

  def self.convert_runtime_to_minutes(runtime_str)
    hours = runtime_str[/(\d)h/, 1].to_i
    minutes = runtime_str[/(\d+)m/, 1].to_i
    (hours * 60) + minutes
  end

end