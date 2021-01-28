class AddSteamJsonToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :steam_image, :string
  end
end
