class Cocktail < ApplicationRecord
  belongs_to :user
  has_many :doses
  has_many :reviews
end
