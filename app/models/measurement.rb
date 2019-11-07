class Measurement < ApplicationRecord
  has_many :doses

  validates :name, :plural, :abbrev, presence: true, allow_blank: false
  validates :name, :abbrev, uniqueness: true
end
