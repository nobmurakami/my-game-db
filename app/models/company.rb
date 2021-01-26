class Company < ApplicationRecord
  has_many :game_companies
  has_many :games, through: :game_companies

  validates :name, uniqueness: true
end
