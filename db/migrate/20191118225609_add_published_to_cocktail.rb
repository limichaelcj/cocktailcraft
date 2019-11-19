class AddPublishedToCocktail < ActiveRecord::Migration[5.2]
  def change
    add_column :cocktails, :published, :boolean, default: false
  end
end
