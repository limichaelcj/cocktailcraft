class AddRemoteImagePathToCocktails < ActiveRecord::Migration[5.2]
  def change
    add_column :cocktails, :remote_image_path, :string
  end
end
