class Api::V1::MoviesController < ApplicationController
  def index
    movies = MovieService.fetch_top_rated
    render json: movies
  end
end
