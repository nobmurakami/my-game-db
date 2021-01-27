class Tagging < ApplicationRecord
  belongs_to :game
  belongs_to :tag
  belongs_to :user
end
