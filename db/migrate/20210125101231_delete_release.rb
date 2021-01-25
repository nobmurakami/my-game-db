class DeleteRelease < ActiveRecord::Migration[6.0]
  def change
    drop_table :releases
  end
end
