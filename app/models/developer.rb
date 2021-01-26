class Developer < ApplicationRecord
  belongs_to :game
  belongs_to :company
end
