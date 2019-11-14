class Review < ApplicationRecord
  belongs_to :cocktail
  belongs_to :user

  validates :user, :cocktail, presence: true
  validates :rating, :title, presence: true, allow_blank: false, allow_nil: false
end
