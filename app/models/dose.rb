class Dose < ApplicationRecord
  belongs_to :cocktail
  belongs_to :ingredient
  belongs_to :measurement, optional: true

  validates :amount, :ingredient_id, presence: true
  validate :unique_cocktail_ingredient

  private

  # validator: a cocktail cannot have repeated doses of same ingredient
  def unique_cocktail_ingredient
    if cocktail.ingredients.map { |x| x.id }.include? ingredient.id
      errors.add(:ingredient, ": #{ingredient.name} is already included in the cocktail")
    end
  end
end
