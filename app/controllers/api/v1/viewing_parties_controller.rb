class Api::V1::ViewingPartiesController < ApplicationController
  def create
    viewing_party = ViewingParty.create_with_invitees(party_params, @current_user)

    if viewing_party
      render json: ViewingPartySerializer.new(viewing_party).serializable_hash, status: :created
    else
      render json: { error: viewing_party.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def party_params
    params.permit(:name, :start_time, :end_time, :movie_id, :movie_title, invitees: [])
  end

end