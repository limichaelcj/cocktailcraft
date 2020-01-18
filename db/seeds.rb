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
  { name: 'part', plural: 's' },
  { name: 'dash', plural: 'es' },
  { name: 'pinch', plural: 'es' },
  { name: 'splash', plural: 'es' },
  { name: 'cube', plural: 's' },
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
  Ingredient.create!(name: item['strIngredient1'].downcase)
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

# cloudinary save config
def cl_photo(public_id, ext)
  version = 1574817501
  signature = Cloudinary::Utils.api_sign_request({
    public_id: public_id,
    version: version
  }, Cloudinary.config.api_secret)
  return "image/upload/v#{version}/#{public_id}.#{ext}##{signature}"
end

# classics
[
  {
    name: 'Old Fashioned',
    desc: "The Old Fashioned is timeless. This simple classic made with rye or bourbon, a sugar cube, Angostura bitters, a thick cube of ice, and an orange twist delivers every time. That’s it — the most popular cocktail in the world.",
    inst: "1) Fill a mixing glass with ice, and add all of the ingredients.\nStir until chilled and diluted, and strain into a glass with fresh ice.\nGarnish with an expressed orange peel and two cherries.",
    photo: 'old-fashioned',
    ext: 'jpg',
    doses: [
      ['whiskey', '2', 'ounce'],
      ['simple syrup', '1/4', 'ounce'],
      ['angostura bitters', '2', 'dash'],
      ['orange peel'],
      ['cherry', '2']
    ]
  }, {
    name: 'Negroni',
    desc: "Easy to make and refreshingly bitter, the Negroni is said to have been invented in Florence by a dauntless Italian count who demanded that the bartender replace the club soda in his Americano with gin. (via Liquor.com)",
    inst: "Add all the ingredients into a mixing glass with ice, and stir until well-chilled.\nStrain into a rocks glass filled with large ice cubes.\nGarnish with an orange peel.",
    photo: 'negroni',
    ext: 'jpg',
    doses: [
      ['gin', '1', 'ounce'],
      ['campari', '1', 'ounce'],
      ['sweet vermouth', '1', 'ounce'],
      ['orange peel']
    ]
  }, {
    name: 'Whiskey Sour',
    desc: 'This dependable drink is an easy fit for whiskey lovers, as well as those weary of the brown spirit: its lemony lift and slight sweetness make it appealing for citrus lovers, too. Its simple recipe calls for whiskey, lemon juice, and sugar.',
    inst: "Add all the ingredients into a shaker and dry-shake (no ice).\nAdd ice and shake again until well-chilled.\nStrain into a chilled coupe.\nTop with 3-5 drops of Angostura bitters.",
    photo: 'whiskey_sour',
    ext: 'jpg',
    doses: [
      ['bourbon', '2', 'ounce'],
      ['lemon juice', '3/4', 'ounce'],
      ['simple syrup', '3/4', 'ounce'],
      ['egg white', '1/2'],
      ['angostura bitters']
    ]
  }, {
    name: 'Daiquiri',
    desc: "The classic Daiquiri is a super simple rum cocktail that’s well-balanced and refreshing. The combination of sweet, sour and spirit is refreshingly tangy and perfect for any occasion.",
    inst: "Add all the ingredients to a shaker and fill with ice.\nShake, and strain into a chilled Martini glass.\nGarnish with a lime wheel.",
    photo: 'daiquiri',
    ext: 'png',
    doses: [
      ['dark rum', '2', 'ounce'],
      ['lime juice', '1', 'ounce'],
      ['simple syrup', '1', 'ounce']
    ]
  }, {
    name: 'Manhattan',
    desc: "It’s hard to stray from the Manhattan, and the recent rise of rye whiskey makes it even more difficult. Spicy rye, sweet vermouth, and two dashes of Angostura, stirred, strained, and garnished with a brandied cherry can make you feel like a true class act.",
    inst: "Add all ingredients into a mixing glass with ice and stir.\nStrain into a coupe glass.\nGarnish with a cherry.",
    photo: 'manhattan',
    ext: 'jpg',
    doses: [
      ['rye whiskey', '2', 'ounce'],
      ['sweet vermouth', '1', 'ounce'],
      ['angostura bitters', '3', 'dash']
    ]
  }, {
    name: 'Martini',
    desc: "A well-made dry Martini is elegance in a glass. The classic mix of gin and dry vermouth ranks No. 6 in the top 50 cocktails of the year.",
    inst: "Add all the ingredients into a mixing glass with ice and stir until very cold.\nStrain into a chilled cocktail glass.\nGarnish with a lemon twist.",
    photo: 'dry_martini',
    ext: 'jpg',
    doses: [
      ['gin', '2.5', 'ounce'],
      ['dry vermouth', '1/2', 'ounce'],
      ['orange bitters', '1', 'dash'],
      ['lemon twist']
    ]
  }, {
    name: 'Espresso Martini',
    desc: "Like a refined Red Bull and vodka for coffee lovers, the Espresso Martini promises a pick-me-up, calm-me-down effect in a tasty package. The after-dinner drink will wake you up while still keeping your buzz going. It’s also been called a Vodka Espresso and Pharmaceutical Stimulant.",
    inst: "Add all ingredients into a shaker with ice and shake until well-chilled.\nDouble-strain into a chilled Martini glass.\nGarnish with three coffee beans and a mint sprig.",
    photo: 'espresso_martini',
    ext: 'jpg',
    doses: [
      ['gin', '2', 'ounce'],
      ['vanilla syrup', '1/2', 'ounce'],
      ['dark chocolate liquer', '1/2', 'ounce'],
      ['brewed espresso', '1', 'ounce']
    ]
  }, {
    name: 'Margarita',
    desc: "The Margarita, in its tart, tangy simplicity, is probably the most well-known tequila cocktail in the world.",
    inst: "Rub the rim of a rocks glass with a lime wedge, dip in salt to coat and set aside.\nAdd the jalapeño coins into a shaker and gently muddle.\nAdd remaining ingredients and ice and shake until well-chilled.\nStrain into prepared glass over fresh ice.\nGarnish with a jalapeño coin.",
    photo: 'margarita',
    ext: 'jpg',
    doses: [
      ['lime wedge', '1'],
      ['jalapeño coins', '2', 'ounce'],
      ['lime juice', '1', 'ounce'],
      ['orange liquer', '1/2', 'ounce'],
      ['agave syrup', '1/2', 'ounce']
    ]
  }, {
    name: 'Mojito',
    desc: "The Mojito might be Cuba’s most popular contribution to cocktail culture. The simple mix of white rum, lime juice, cane sugar, and soda (with muddled mint, please) is fresh and tropical, and it’s a classic that we don’t expect to disappear any time soon.",
    inst: "Lightly muddle the mint in a shaker.\nAdd the rum, lime juice, simple syrup and ice and give it a brief shake.\nStrain into a highball glass over fresh ice.\nTop with the club soda.\nGarnish with a mint sprig and lime wheel.",
    photo: 'mojito',
    ext: 'jpg',
    doses: [
      ['white rum', '2', 'ounce'],
      ['mint leaves', '3'],
      ['lime juice', '3/4', 'ounce'],
      ['simple syrup', '1/2', 'ounce'],
      ['club soda', 'to top'],
      ['mint sprig'],
      ['lime wheel']
    ]
  }, {
    name: 'Bloody Mary',
    desc: "The Bloody Mary is a vodka-soaked nutritional breakfast and hangover cure all in one. The brunch-time staple is best enjoyed with a house mix of tomato juice, vodka, and spices. And, if it’s your thing, an array of garnishes, from celery and olives, to bacon, to entire cheeseburgers, are known to make appearances.",
    inst: "Pour some celery salt onto a small plate.\nRub the juicy side of the lemon or lime wedge along the lip of a pint glass.\nRoll the outer edge of the glass in celery salt until fully coated.\nFill with ice and set aside.\nSqueeze the lemon and lime wedges into a shaker and drop them in.\nAdd the remaining ingredients and ice and shake gently.\nStrain into the prepared glass.\nGarnish with a parsley sprig, 2 speared green olives and a lime wedge and a celery stalk (optional).",
    photo: 'bloody_mary',
    ext: 'jpg',
    doses: [
      ['lemon wedge', '1'],
      ['lime wedge', '1'],
      ['vodka', '2', 'ounce'],
      ['tomato juice', '4', 'ounce'],
      ['tabasco sauce', '2', 'dash'],
      ['prepared horseradish', '2', 'teaspoon'],
      ['worcestershire sauce', '2', 'dash'],
      ['celery salt', '1', 'pinch'],
      ['ground black pepper', '1', 'pinch'],
      ['smoked paprika', '1', 'pinch'],
      ['green olives'],
      ['parsely sprig'],
      ['celery stalk']
    ]
  }, {
    name: "Piña Colada",
    desc: "This tropical classic—a blend of rum, coconut, pineapple and lime juice—dates back more than a half century, when it was the drink of the day in San Juan, Puerto Rico.",
    inst: "Add all ingredients into a shaker with ice and shake vigorously (20-30 seconds).\nStrain into a chilled Hurricane glass over pebble ice.\nGarnish with a pineapple wedge and pineapple leaf.",
    photo: 'pina_colada',
    ext: 'jpg',
    doses: [
      ['light rum', '2', 'ounce'],
      ['cream of coconut', '1.5', 'ounce'],
      ['pineapple juice', '1.5', 'ounce'],
      ['lime juice', '1/2', 'ounce'],
      ['pineapple wedge'],
      ['pineapple leaf']
    ]
  }, {
    name: 'Gimlet',
    desc: "Two parts gin, one part lime juice, and one-half part sweetener, the Gimlet is an easy sipper that inspires many iterations.",
    inst: "Add all the ingredients into a shaker with ice and shake until chilled.\nStrain into a coupe glass.\nGarnish with a lime twist.",
    photo: 'gimlet',
    ext: 'jpg',
    doses: [
      ['cognac brandy', '1.5', 'ounce'],
      ['lime juice', '3/4', 'ounce'],
      ['simple syrup', '3/4', 'ounce']
    ]
  }, {
    name: 'Cosmopolitan',
    desc: "Made iconic by TV’s “Sex and the City,” the Cosmo mixes vodka, triple sec, cranberry juice, and lime juice. It’s the liquid soul of the aspirational 1990s female, and still resonates with the world today. (Incidentally, Carrie Bradshaw has reportedly moved on to Stella Artois.)",
    inst: "Add all ingredients into a shaker with ice and shake.\nStrain into a chilled cocktail glass.\nGarnish with a lime wheel.",
    photo: 'cosmopolitan',
    ext: 'jpg',
    doses: [
      ['citrus vodka', '1.5', 'ounce'],
      ['cointreau', '1', 'ounce'],
      ['lime juice', '1/2', 'ounce'],
      ['cranberry juice', '1', 'dash'],
      ['lime wheel']
    ]
  }, {
    name: 'Vesper',
    desc: "James Bond drinks vodka Martinis, shaken; sensible people drink Martinis the way they’re meant to be: with gin, stirred. Consider the Vesper a compromise, using both vodka and gin, as well as Lillet vermouth.",
    inst: "Add all the ingredients into a mixing glass with ice and stir (or, if preparing the Bond way, shake).\nStrain into a chilled cocktail glass.\nTwist a slice of lemon peel over the drink, rub along the rim of the glass, and drop it in.",
    photo: 'vesper',
    ext: 'jpg',
    doses: [
      ['gin', '3', 'ounce'],
      ['vodka', '1', 'ounce'],
      ['lillet blanc aperitif', '1/2', 'ounce'],
      ['lemon twist']
    ]
  }, {
    name: 'Long Island Iced Tea',
    desc: "Long Island Iced Tea is a timeless anomaly: vodka, gin, tequila, rum, triple sec, and cola in big ol’ glass. It’s sweet, sticky, boozy, made for making memories (and promptly forgetting them).",
    inst: "Add all ingredients except the cola into a Collins glass with ice.\nTop with a splash of the cola and stir briefly.\nGarnish with a lemon wedge.\nServe with a straw.",
    photo: 'long_island',
    ext: 'jpg',
    doses: [
      ['vodka', '3/4', 'ounce'],
      ['white rum', '3/4', 'ounce'],
      ['silver tequila', '3/4', 'ounce'],
      ['gin', '3/4', 'ounce'],
      ['triple sec', '3/4', 'ounce'],
      ['simple syrup', '3/4', 'ounce'],
      ['lemon juice', '3/4', 'ounce'],
      ['cola', 'to top'],
    ]
  }, {
    name: 'White Russian',
    desc: "Created in 1949 by a Belgian bartender named Gustave Tops, and popularized by the 1998 film “The Big Lebowski,” the White Russian continues to be a world-wide favorite. The White Russian combines heavy cream (or half and half), vodka, and coffee liqueur for a luxurious nightcap.",
    inst: "Add the vodka and Kahlúa to an Old Fashioned glass with ice.\nTop with the heavy cream and stir.",
    photo: 'white_russian',
    ext: 'jpg',
    doses: [
      ['vodka', '2', 'ounce'],
      ['kahlúa', '1', 'ounce'],
      ['heavy cream', '1', 'splash']
    ]
  }
].each do |c|
  cocktail = Cocktail.create!(
    name: c[:name],
    description: c[:desc],
    instructions: c[:inst],
    photo: cl_photo(c[:photo], c[:ext]),
    published: true
  )

  c[:doses].each do |d|
    ingr = Ingredient.find_by(name: d[0])
    unless ingr
      ingr = Ingredient.create!(name: d[0])
    end
    Dose.create!(
      cocktail: cocktail,
      ingredient: ingr,
      amount: d[1] || '',
      measurement: d[2] ? Measurement.find_by(name: d[2]) : nil
    )
  end
end

# get cocktail names from seventhsanctum
print "- Requesting names from seventhsanctum.com..."
doc = Nokogiri::HTML(open("https://www.seventhsanctum.com/generate.php?Genname=mixeddrink"))
cnames = doc.css('div.Generator.Results > div > div').map { |div| div.inner_html }
if cnames.empty?
  puts "scrape failed, reverting to precompiled names."
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
else
  puts "OK"
end

# seed random cocktails
puts "- Creating cocktails with doses..."
cnames.each_with_index do |name, i|
  cocktail = Cocktail.create!(
    name: name,
    description: Faker::Food.description,
    instructions: Array.new(rand(3...6)) { Faker::Lorem.paragraphs.join(' ') }.join(' '),
    user: User.find(rand(1...User.all.count)),
    photo: cl_photo("cocktail_stock#{rand(0..9)}", 'jpg'),
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
