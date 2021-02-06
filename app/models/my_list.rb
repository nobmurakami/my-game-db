class MyList < ApplicationRecord
  belongs_to :user
  has_many :my_list_games
  has_many :games ,through: :my_list_games
end
