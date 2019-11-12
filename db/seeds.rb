# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'json'
require 'open-uri'
require 'faker'

ingredients_url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
ingredients_data = JSON.parse(open(ingredients_url).read)

puts "Seeding database..."

puts "Seeding measurements..."
[
  { name: 'pinch', plural: 'es' },
  { name: 'dash', plural: 'es' },
  { name: 'splash', plural: 'es' },
  { name: 'liter', plural: 's', abbrev: 'L'},
  { name: 'milliliter', plural: 's', abbrev: 'mL'},
  { name: 'ounce', plural: 's', abbrev: 'oz' },
  { name: 'gram', plural: 's', abbrev: 'g' },
  { name: 'kilogram', plural: 's', abbrev: 'kg' },
  { name: 'pound', plural: 's', abbrev: 'lbs' },
  { name: 'teaspoon', plural: 's', abbrev: 'tsp' },
  { name: 'tablespoon', plural: 's', abbrev: 'Tbsp' },
  { name: 'cup', plural: 's', abbrev: 'C' },
  { name: 'pint', plural: 's', abbrev: 'pt' }
].each do |m|
  Measurement.create!(m)
end

puts "Seeding common ingredients..."
ingredients_data['drinks'].each do |item|
  Ingredient.create(name: item['strIngredient1'].downcase)
end

puts "Seeding users..."

6.times do |i|
  name = Faker::Name.middle_name
  username = Faker::Internet.username(specifier: name)
  email = Faker::Internet.email(name: name)
  pw = Faker::Internet.password
  puts "#{i+1}) #{username} :: #{email} :: #{pw}"
  User.create!(name: username, email: email, password: pw, password_confirmation: pw)
end

all_users = User.all

puts "Seeding cocktails..."

# seed cocktails
20.times do |i|
  name = Faker::Coffee.blend_name
  description = Faker::Lovecraft.sentence
  Cocktail.create!(name: name, description: description, user: i > 10 ? nil : User.find(rand(1...all_users.count)))
end

puts "Seeding complete."
