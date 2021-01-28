class AddSteamToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :steam, :string
  end
end
