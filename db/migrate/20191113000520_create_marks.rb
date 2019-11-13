class CreateMarks < ActiveRecord::Migration[5.2]
  def change
    create_table :marks do |t|
      t.references :user, foreign_key: true
      t.references :cocktail, foreign_key: true

      t.timestamps
    end
  end
end
