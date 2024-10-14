class ViewingParty < ApplicationRecord
  belongs_to :host, class_name: 'User'
  has_many :viewing_party_users
  has_many :users, through: :viewing_party_users

  validates :start_time, :end_time, :movie_id, :movie_title, presence: true
  validates :name, presence: true, uniqueness: true

  def self.create_with_invitees(party_params, host, movie_runtime)
    missing_attributes = validate_party_params(party_params)
    unless missing_attributes.empty?
      return nil
    end

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

   def self.validate_party_params(party_params)
    missing_attributes = []
    missing_attributes << 'name' if party_params[:name].blank?
    missing_attributes << 'movie_id' if party_params[:movie_id].blank?
    missing_attributes << 'movie_title' if party_params[:movie_title].blank?
    missing_attributes << 'start_time' if party_params[:start_time].blank?
    missing_attributes << 'end_time' if party_params[:end_time].blank?
    missing_attributes
   end

  def long_enough?(movie_runtime)
    party_duration = ((end_time - start_time) / 60).to_i
    party_duration >= movie_runtime.to_i
  end

  def self.convert_runtime_to_minutes(runtime_str)
    return 0 if runtime_str.nil?

    hours = runtime_str[/(\d)h/, 1].to_i
    minutes = runtime_str[/(\d+)m/, 1].to_i
    (hours * 60) + minutes
  end

end