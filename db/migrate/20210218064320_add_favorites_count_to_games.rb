class AddFavoritesCountToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :favorites_count, :integer, null: false, default: 0
  end
end
