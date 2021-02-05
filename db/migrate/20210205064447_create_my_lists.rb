class CreateMyLists < ActiveRecord::Migration[6.0]
  def change
    create_table :my_lists do |t|
      t.string :name, null: false
      t.references :user, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
