class Measurement < ApplicationRecord
  has_many :doses

  validates :name, :plural, :abbrev, presence: true
  validates :name, :abbrev, uniqueness: true
end
