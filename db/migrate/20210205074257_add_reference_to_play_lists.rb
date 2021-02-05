class AddReferenceToPlayLists < ActiveRecord::Migration[6.0]
  def change
    add_reference :play_lists, :my_list, foreign_key: true
  end
end
