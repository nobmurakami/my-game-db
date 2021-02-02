class Platform < ApplicationRecord
  has_many :games

  validates :name, uniqueness: { case_sensitive: false }
end
