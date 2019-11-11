class Dose < ApplicationRecord
  belongs_to :cocktail
  belongs_to :ingredient
  belongs_to :measurement

  validates :amount, :ingredient_id, :measurement_id, presence: true
end
