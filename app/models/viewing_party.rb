class ViewingParty < ApplicationRecord
  belongs_to :host, class_name: 'User'
  has_many :viewing_party_users
  has_many :users, through: :viewing_party_users

  validates :name, :start_time, :end_time, :movie_id, :movie_title, presence: true

  def self.create_with_invitees(party_params, host)
    viewing_party = new(party_params.except(:invitees))
    viewing_party.host = host

    if viewing_party.save
      party_params[:invitees].each do |invitee_id|
        user = User.find_by(id: invitee_id)
        viewing_party.users << user if user
      end
      viewing_party
    else
      nil
    end
  end
end