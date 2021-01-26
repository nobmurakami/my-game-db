class Tag < ApplicationRecord
  has_many :taggings
  has_many :games, through: :taggings

  validates :name, uniqueness: true
end
