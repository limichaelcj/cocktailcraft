class Cocktail < ApplicationRecord
  belongs_to :user, optional: true
  has_many :doses
  has_many :reviews

  validates :name, presence: true, allow_blank: false
end
