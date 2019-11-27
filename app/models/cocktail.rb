class Cocktail < ApplicationRecord
  include PgSearch::Model

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

  pg_search_scope :search_keyword, {
    using: { tsearch: {
      any_word: true,
      prefix: true,
      dictionary: 'english'
    } },
    against: {
      name: 'A',
      description: 'C'
    },
    associated_against: {
      ingredients: { name: 'B' }
    }
  }

  def creator
    user.nil? ? 'Classic Collection' : user.name
  end

  def image_path
    puts "\nDEBUG\n"
    puts photo.url
    photo.url ? ApplicationController.helpers.cl_image_path(photo.url) : ApplicationController.helpers.image_path('default_cocktail.png')
  end

  def rating
    avg = reviews.map { |r| r.rating }.reduce(:+) / reviews.count.to_f
    (avg * 10).round / 10.0
  end

end
