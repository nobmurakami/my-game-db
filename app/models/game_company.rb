class GameCompany < ApplicationRecord
  belongs_to :game
  belongs_to :company

  enum company_type: { developer: 0, publisher: 1 }
end
