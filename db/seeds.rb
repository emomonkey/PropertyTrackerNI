# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
SearchParams.create(searchtitle: 'N.Ireland', searchparam:'Waringstown',  county:'Co.Armagh')
SearchParams.create(searchtitle: 'N.Ireland', searchparam:'Donaghcloney', county:'Co.Armagh')
SearchType.create(searchtext: 'Biggest price increase')
SearchType.create(searchtext: 'Biggest price decrease')
SearchType.create(searchtext: 'Newest Additions')
SearchType.create(searchtext: 'Just Sold')