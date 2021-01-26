class Company < ApplicationRecord
  has_many :developers
  has_many :games, through: :developers
  has_many :publishers
  has_many :games, through: :publishers
end
