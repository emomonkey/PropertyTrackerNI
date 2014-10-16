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
SearchType.create(searchtext:'Historic Avg')
SearchType.create(searchtext:'Historic Min')
SearchType.create(searchtext:'Volume Sales')
SearchType.create(searchtext:'Volume Summary Property Types')
SearchType.create(searchtext:'Sold Summary Prop Type')
SearchType.create(searchtext:'Highest Price Increase in Cnty')
SearchType.create(searchtext:'Highest Vol Increase in Cnty')
SearchType.create(searchtext:'Historic Avg Overall')
SearchType.create(searchtext:'Volume Summary Property Types Overall')
SearchType.create(searchtext:'Monthly Volume Summary Property Types')
SearchType.create(searchtext:'Monthly Average Summary Property Types')