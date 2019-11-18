class Review < ApplicationRecord
  belongs_to :cocktail
  belongs_to :user

  validates :user, :cocktail, presence: true
  validates :rating, :title, presence: true, allow_blank: false, allow_nil: false
  validate :unique_review

  private

  def unique_review
    if Review.where(cocktail: cocktail, user: user).any?
      errors.add(:user, "has already reviewed this cocktail.")
    end
  end
end
