class AddYouTubeToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :youtube, :string
  end
end
