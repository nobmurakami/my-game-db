class CreateReleases < ActiveRecord::Migration[6.0]
  def change
    create_table :releases do |t|
      t.references :game,             null: false, foreign_key: true
      t.references :platform,             null: false, foreign_key: true
      t.references :region,             null: false, foreign_key: true
      t.timestamps
    end
  end
end
