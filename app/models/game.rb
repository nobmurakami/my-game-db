class Game < ApplicationRecord
  has_one_attached :image
  belongs_to :platform

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :game_genres, dependent: :destroy
  has_many :genres, through: :game_genres

  has_many :game_companies
  has_many :companies, through: :game_companies

  has_many :developer_game_companies, -> { where(type: 'developer') }, class_name: 'GameCompany'
  has_many :developers, through: :developer_game_companies, source: :company

  has_many :publisher_game_companies, -> { where(type: 'publisher') }, class_name: 'GameCompany'
  has_many :publishers, through: :publisher_game_companies, source: :company
end
