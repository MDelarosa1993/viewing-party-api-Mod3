class Api::V1::ViewingPartiesController < ApplicationController
  before_action :authorize_api_key, only: [:create, :update]
  def create
    viewing_party = ViewingParty.create_with_invitees(party_params, @current_user)

    if viewing_party
      render json: ViewingPartySerializer.new(viewing_party)
    else
      render json: { error: viewing_party.errors.full_messages }
    end
  end

  def update
    viewing_party = ViewingParty.find_by(id: params[:id])
    new_invitee = User.find_by(id: params[:invitee_user_id])
    
    if viewing_party.nil?
      return render json: { error: 'Viewing Party not found' }, status: :not_found
    elsif new_invitee.nil?
      return render json: { error: 'Invitee not found' }, status: :not_found
    end

    unless viewing_party.users.include?(new_invitee)
      viewing_party.users << new_invitee
    end

    render json: ViewingPartySerializer.new(viewing_party).serializable_hash, status: :ok
  end




  private

  def party_params
    params.permit(:name, :start_time, :end_time, :movie_id, :movie_title, invitees: [])
  end

  def authorize_api_key
    @current_user = User.find_by(api_key: params[:api_key])
    render json: { error: 'Invalid API key' }, status: :unauthorized unless @current_user
  end

end