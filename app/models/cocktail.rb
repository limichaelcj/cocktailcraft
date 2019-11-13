class Cocktail < ApplicationRecord
  belongs_to :user, optional: true
  has_many :doses, dependent: :delete_all
  has_many :ingredients, through: :doses
  has_many :marks
  has_many :markers, through: :marks, source: :user
  has_many :reviews

  validates :name, presence: true, allow_blank: false

  mount_uploader :photo, PhotoUploader
end
