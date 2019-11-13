class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :cocktail

  validates :user, :cocktail, presence: true
end
