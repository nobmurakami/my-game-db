class CreateMyListGames < ActiveRecord::Migration[6.0]
  def change
    create_table :my_list_games do |t|
      t.references :my_list, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.timestamps
    end
  end
end
