class RemoveRegionFromGames < ActiveRecord::Migration[6.0]
  def change
    remove_reference :games, :region, null: false, foreign_key: true
  end
end
