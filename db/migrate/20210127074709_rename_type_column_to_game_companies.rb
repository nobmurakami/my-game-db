class RenameTypeColumnToGameCompanies < ActiveRecord::Migration[6.0]
  def change
    rename_column :game_companies, :type, :company_type
  end
end
