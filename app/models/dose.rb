class Dose < ApplicationRecord
  belongs_to :cocktail
  belongs_to :ingredient
  belongs_to :measurement
end
