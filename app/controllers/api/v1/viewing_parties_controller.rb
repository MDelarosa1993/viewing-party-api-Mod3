class Api::V1::ViewingPartiesController < ApplicationController
  before_action :authorize_api_key, only: [:create, :update]

  def create
    begin
      viewing_party = ViewingParty.create_with_invitees(party_params, @current_user)
      render json: ViewingPartySerializer.new(viewing_party), status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.record.errors.full_messages, status: :unprocessable_entity }, status: :unprocessable_entity
    end
  end

  def update
    viewing_party = ViewingParty.find_by(id: params[:id])
    new_invitee = User.find_by(id: params[:invitee_user_id])

    if viewing_party.nil?
      return render json: ErrorSerializer.format_error('Viewing Party not found', :not_found), status: :not_found
    elsif new_invitee.nil?
      return render json: ErrorSerializer.format_error('Invitee not found', :not_found), status: :not_found
    end

    unless viewing_party.users.include?(new_invitee)
      viewing_party.users << new_invitee
    end

    render json: ViewingPartySerializer.new(viewing_party)
  end

  def index 
    viewing_party = ViewingParty.all 
    render json: ViewingPartySerializer.new(viewing_party)
  end

  private

  def party_params
    params.permit(:name, :start_time, :end_time, :movie_id, :movie_title, invitees: [])
  end

   def authorize_api_key
    @current_user = User.find_by(api_key: params[:api_key])
    if @current_user.nil?
      error = ErrorMessage.new('Invalid API key', :unauthorized)
      render json: ErrorSerializer.format_error(error), status: :unauthorized
    end
   end
end
