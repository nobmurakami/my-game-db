class ChangeListsToPlayLists < ActiveRecord::Migration[6.0]
  def change
    rename_table :lists, :play_lists
  end
end
