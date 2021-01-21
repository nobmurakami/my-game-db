class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :title, null: false
      t.text :description	
      t.integer :metascore	
      t.timestamps
    end
  end
end
