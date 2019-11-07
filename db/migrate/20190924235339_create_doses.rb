class CreateDoses < ActiveRecord::Migration[5.2]
  def change
    create_table :doses do |t|
      t.string :amount
      t.references :cocktail, foreign_key: true
      t.references :ingredient, foreign_key: true
      t.references :measurement, foreign_key: true

      t.timestamps
    end
  end
end
