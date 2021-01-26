class GameCompany < ApplicationRecord
  belongs_to :game
  belongs_to :company

  enum type: { developer: 0, publisher: 1 }
end
