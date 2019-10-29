# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

# seed fake cocktails
12.times do
  name = Faker::Coffee.blend_name
  description = [Faker::Dessert.flavor, Faker::Dessert.flavor, Faker::Dessert.topping].join(' ')
  Cocktail.create!(name: name, description: description)
end
