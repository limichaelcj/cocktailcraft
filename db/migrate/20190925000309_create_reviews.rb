class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.string :text
      t.references :cocktail, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
