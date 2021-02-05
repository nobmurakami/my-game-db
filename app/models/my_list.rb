class MyList < ApplicationRecord
  belongs_to :user
  has_many :play_lists
  has_many :games, through: :play_lists

  validates :name, presence: true
end
