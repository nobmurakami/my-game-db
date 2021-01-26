class Game < ApplicationRecord
  has_one_attached :image
  belongs_to :platform
end
