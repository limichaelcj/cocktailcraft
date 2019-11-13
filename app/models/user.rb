class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :cocktails
  has_many :marks
  has_many :marked, through: :marks, source: :cocktail
  has_many :reviews

  # uniqueness validation
  validates :name, :email, presence: :true, allow_blank: false, uniqueness: { case_sensitive: false }
  # validate user name via regex
  validates_format_of :name, with: /^[^@]+$/, multiline: true

end
