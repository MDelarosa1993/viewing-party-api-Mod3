class Api::V1::MoviesController < ApplicationController
  def index
    if params[:query]
      movies = MovieService.search_by_name(params[:query])
    else
      movies = MovieService.fetch_top_rated
    end
      render json: movies
  end

  def show
    movie_id = params[:id]  
    movie_details = MovieService.get_movie_details(movie_id)
    render json: movie_details
  end
end
