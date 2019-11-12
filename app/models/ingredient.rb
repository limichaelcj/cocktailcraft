class Ingredient < ApplicationRecord
  has_many :doses
  has_many :recipes, through: :doses, source: :cocktail

  validates :name, presence: true, allow_blank: false, uniqueness: true
end
