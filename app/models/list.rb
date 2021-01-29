class List < ApplicationRecord
  belongs_to :user
  belongs_to :game
  belongs_to :play_status

  enum list_type: { want: 0, playing: 1, played: 2 }
end
