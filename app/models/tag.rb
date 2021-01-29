class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :games, through: :taggings

  validates :name, uniqueness: true
end
