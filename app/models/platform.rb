class Platform < ApplicationRecord
  has_many :games

  validates :name, uniqueness: true
end
