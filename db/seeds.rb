# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Palette.count == 0
	Palette.create(:ref => "1", :c1 => "FF5B2B", :c2 => "B1221C", :c3 => "34393E", :c4 => "8CC6D7", :c5 => "FFDA8C")
	Palette.create(:ref => "2", :c1 => "FFF200", :c2 => "E8860C", :c3 => "FF0000", :c4 => "780CE8", :c5 => "0D8AFF")
	Palette.create(:ref => "3", :c1 => "8AFF80", :c2 => "E8D280", :c3 => "FF9680", :c4 => "BC80E8", :c5 => "80D8FF")
	Palette.create(:ref => "4", :c1 => "6700FF", :c2 => "0CCAE8", :c3 => "3EFF00", :c4 => "E8AF0C", :c5 => "FF1E00")
	Palette.create(:ref => "5", :c1 => "8CABBF", :c2 => "5E727F", :c3 => "BBE4FF", :c4 => "2F3940", :c5 => "A8CDE5")
end

if Polices.count == 0
	Polices.create(:ref => "1", :nom => "Lato")
	Polices.create(:ref => "2", :nom => "Roboto")
	Polices.create(:ref => "3", :nom => "Baloo")
	Polices.create(:ref => "4", :nom => "Bree Serif")
end

if Image.count == 0
	Image.create(:ref => "1", :nom => "")
	Image.create(:ref => "2", :nom => "bandeau_music.jpg")
	Image.create(:ref => "3", :nom => "bandeau_cahier.jpg")
end

if Layout.count == 0
	Layout.create(:ref => "1", :margin => "20px", :minwidth => "250px", :radius => "5px")
	Layout.create(:ref => "2", :margin => "0", :minwidth => "320px", :radius => "0")
	Layout.create(:ref => "3", :margin => "30px", :minwidth => "200px", :radius => "30px")
end
