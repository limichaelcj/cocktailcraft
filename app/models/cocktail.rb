class Cocktail < ApplicationRecord
  belongs_to :user, optional: true
  has_many :doses, dependent: :destroy
  has_many :ingredients, through: :doses
  has_many :marks
  has_many :markers, through: :marks, source: :user
  has_many :reviews, dependent: :destroy
  has_many :reviewers, through: :reviews, source: :user

  validates :name, presence: true, allow_blank: false
  validates :description, :instructions, presence: true, allow_blank: true

  mount_uploader :photo, PhotoUploader
end
