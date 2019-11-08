class AddInstructionsToCocktail < ActiveRecord::Migration[5.2]
  def change
    add_column :cocktails, :instructions, :text
  end
end
