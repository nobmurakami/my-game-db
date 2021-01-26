class Game < ApplicationRecord
  has_one_attached :image
  belongs_to :platform
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
end
