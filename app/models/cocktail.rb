class Cocktail < ApplicationRecord
  belongs_to :user, optional: true
  has_many :doses
  has_many :reviews
end
