class User < ApplicationRecord
  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: { require: true }
  has_secure_password
  has_secure_token :api_key

  has_many :viewing_parties, foreign_key: :host_id
  has_many :viewing_party_users
  has_many :viewing_parties_invited, through: :viewing_party_users, source: :viewing_party

  def viewing_parties_hosted
    ViewingParty.where(host_id: id) 
  end

end