class AddDateToReleases < ActiveRecord::Migration[6.0]
  def change
    add_column :releases, :date, :date
  end
end
