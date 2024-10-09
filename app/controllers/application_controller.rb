class ApplicationController < ActionController::API
  before_action :authorize_api_key

  private

  def authorize_api_key
    @current_user = User.find_by(api_key: params[:api_key])
    render json: { error: 'Invalid API key' }, status: :unauthorized unless @current_user
  end
end
