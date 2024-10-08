class ViewingPartySerializer < ActiveModel::Serializer
  attributes :id, :name, :start_time, :end_time, :movie_id, :movie_title

  
end