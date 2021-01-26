class AddReferenceToGames < ActiveRecord::Migration[6.0]
  def change
    add_reference :games, :platform, foreign_key: true
    add_reference :games, :region, foreign_key: true
  end
end
