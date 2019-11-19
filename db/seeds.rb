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
  { name: 'dash', plural: 'es' },
  { name: 'pinch', plural: 'es' },
  { name: 'splash', plural: 'es' },
  { name: 'ounce', plural: 's', abbrev: 'oz' },
  { name: 'gram', plural: 's', abbrev: 'g' },
  { name: 'milliliter', plural: 's', abbrev: 'mL'},
  { name: 'pound', plural: 's', abbrev: 'lbs' },
  { name: 'kilogram', plural: 's', abbrev: 'kg' },
  { name: 'teaspoon', plural: 's', abbrev: 'tsp' },
  { name: 'tablespoon', plural: 's', abbrev: 'Tbsp' },
  { name: 'cup', plural: 's', abbrev: 'C' },
  { name: 'pint', plural: 's', abbrev: 'pt' },
  { name: 'liter', plural: 's', abbrev: 'L'}
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

# seed random cocktails
20.times do |i|
  cocktail = Cocktail.create!(
    name: Faker::Coffee.blend_name,
    description: Faker::Books::Lovecraft.sentence,
    instructions: Array.new(rand(3...6)) { Faker::Lorem.paragraphs.join(' ') }.join(' '),
    user: i > 10 ? nil : User.find(rand(1...all_users.count)),
    published: true
  )

  (3...rand(4...8)).each do |n|
    Dose.create!(
      cocktail: cocktail,
      ingredient: Ingredient.find(rand(1...Ingredient.all.count)),
      amount: rand(1...5),
      measurement: Measurement.find(rand(1...Measurement.all.count))
    )
  end
end

puts "Seeding complete."
