class PlayList < ApplicationRecord
  belongs_to :user
  belongs_to :game

  enum play_status: { want: 0, playing: 1, played: 2 }
end
