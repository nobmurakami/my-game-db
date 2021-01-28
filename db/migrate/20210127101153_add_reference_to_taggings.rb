class AddReferenceToTaggings < ActiveRecord::Migration[6.0]
  def change
    add_reference :taggings, :user, null: false, foreign_key: true
  end
end
