class ViewingParty < ApplicationRecord
  belongs_to :host, class_name: 'User'
  has_many :viewing_party_users
  has_many :users, through: :viewing_party_users

  validates :name, :start_time, :end_time, :movie_id, :movie_title, presence: true
end