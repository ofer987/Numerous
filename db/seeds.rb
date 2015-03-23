# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

FilesizeType.create!(name: 'original')
FilesizeType.create!(name: 'thumbnail',  width: 150,   height: 150)
FilesizeType.create!(name: 'large',      width: 2000,  height: 2000)
FilesizeType.create!(name: 'medium',     width: 1000,  height: 1000)
FilesizeType.create!(name: 'small',      width: 800,   height: 800)
