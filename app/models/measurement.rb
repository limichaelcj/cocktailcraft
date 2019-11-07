class Measurement < ApplicationRecord
  has_many :doses

  validates :name, presence: true, allow_blank: false, uniqueness: true
  validates :plural, presence: true, allow_blank: true, allow_nil: true
  validates :abbrev, uniqueness: true, allow_nil: true
end
