class Game < ApplicationRecord
  has_one_attached :image
  belongs_to :platform
  belongs_to :region

  validates :title, presence: true
  validates :metascore, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_blank: true }
end
