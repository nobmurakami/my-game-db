class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :game, counter_cache: true
end
