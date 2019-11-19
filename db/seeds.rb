# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'nokogiri'
require 'json'
require 'open-uri'
require 'faker'

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
print "- Requesting ingredients from thecocktaildb.com/api..."
ingredients_url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
ingredients_data = JSON.parse(open(ingredients_url).read)
ingredients_data['drinks'].each do |item|
  Ingredient.create(name: item['strIngredient1'].downcase)
end
puts "OK"

puts "Seeding users..."

unames = []
while unames.count < 6 do
  name = Faker::Games::ElderScrolls.name
  if not unames.include? name
    unames << name
  end
end

unames.each do |name|
  username = Faker::Internet.username(specifier: name)
  email = Faker::Internet.email(name: name)
  pw = Faker::Internet.password
  puts "- #{username} :: #{email} :: #{pw}"
  User.create!(name: username, email: email, password: pw, password_confirmation: pw)
end

puts "Seeding cocktails..."

# get cocktail names from seventhsanctum
# print "- Requesting names from seventhsanctum.com..."
# doc = Nokogiri::HTML(open("https://www.seventhsanctum.com/generate.php?Genname=mixeddrink"))
# cnames = doc.css('div.Generator.Results > div > div').map { |div| div.inner_html }
# puts "OK"
cnames = [
  "Abundance Mix",
  "Angelic White Imagining",
  "Brown Abyss",
  "Chop Float",
  "Devilish Magical Moonrise",
  "Elemental Angelic Soldier",
  "Famous Low Greatness",
  "Forest Paradise",
  "High Western Cut",
  "Holy Demonic Sailor",
  "Insane Passionate Scarlet",
  "Kiwi Lime Mix",
  "Modest Orange Walnut",
  "Raging Cocoa",
  "Royal Squirt",
  "Tea Peach Martini",
  "Unholy King's Rain",
  "Unholy Nasty Garnet",
  "Valorous Sea",
  "Wonderful Annihilation Shandy",
]

# seed random cocktails
puts "- Creating cocktails with doses..."
cnames.each_with_index do |name, i|
  cocktail = Cocktail.create!(
    name: name,
    description: Faker::Food.description,
    instructions: Array.new(rand(3...6)) { Faker::Lorem.paragraphs.join(' ') }.join(' '),
    user: i > 10 ? nil : User.find(rand(1...User.all.count)),
    published: true
  )

  (3...rand(4...8)).each do |n|
    Dose.create!(
      cocktail: cocktail,
      ingredient: Ingredient.find(rand(1...Ingredient.all.count)),
      amount: rand(2...5),
      measurement: Measurement.find(rand(1...Measurement.all.count))
    )
  end
end

# seed reviews
puts "Seeding reviews..."
Cocktail.all.each do |c|
  User.all.shuffle[0, rand(1..4)].each do |user|
    Review.create!({
      cocktail: c,
      user: user,
      rating: rand(1..5),
      title: Faker::Books::Lovecraft.word,
      text: Faker::Restaurant.review
    })
  end
end

puts "Seeding complete."
