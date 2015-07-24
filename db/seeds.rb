# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Parameter.create({name: 'import_path', value: '/tmp/wall'})

Group.create([
  {name: 'Miscellaneous'}, {name:'Anime & Manga'}, {name: 'Vehicle'}
])