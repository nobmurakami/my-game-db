class Game < ApplicationRecord
  has_one_attached :image
  belongs_to :platform
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :game_genres, dependent: :destroy
  has_many :genres, through: :game_genres
  has_many :developers, dependent: :destroy
  has_many :publishers, dependent: :destroy
  has_many :developer_companies, through: :developers, source: :company
  has_many :publisher_companies, through: :publishers, source: :company
end
