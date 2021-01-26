class Game < ApplicationRecord
  has_one_attached :image
  belongs_to :platform
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :game_genres
  has_many :genres, through: :game_genres
  has_many :developers
  has_many :publishers
end
