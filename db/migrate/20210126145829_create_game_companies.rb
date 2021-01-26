class CreateGameCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :game_companies do |t|
      t.references :game, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.integer :type, null: false
      t.timestamps
    end
  end
end
