# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

[Palette, Polices, Image, Layout].each do |table|
 ActiveRecord::Base.connection.execute("DELETE FROM #{table.table_name}")
end
#
# Remplissage de Desk Draw Fiche sur la base de folders existants
#
# [Desk, Draw, Fiche].each do |table|
#  ActiveRecord::Base.connection.execute("DELETE FROM #{table.table_name}")
# end
# arr = Array.new
# usercpte = Array.new
# userpub = Array.new
# d = Dir.entries("./public/folders/")
# liste_exclus = [".", "..", ".DS_Store"]
# d = d - liste_exclus
# # Calcul des eleves par comptes pour publish
# j = 0
# d.each do |f|
#   desk = Dir.entries("./public/folders/"+f)
#   desk = desk - liste_exclus
#   usercpte = User.where("nom = '#{f}'", "is_admin = 0" ).all
#   userpub[j] = "1"*(usercpte.count-1)
#   puts userpub[j]
#   puts('ooooooo')
#   j = j + 1
# end
# #
# j = 0
# d.each do |f|
#   desk = Dir.entries("./public/folders/"+f)
#   desk = desk - liste_exclus
#   @compte = Compte.where("nom = '#{f}'").take
#   desk.each_with_index do |g, index|
#       Desk.create(:name => g.gsub(/_/, ' '), :route => g, :publish => userpub[j], :compte_id => @compte.id, :rang => index)
#       draw = Dir.entries("./public/folders/#{f}/#{g}")
#       draw = draw - liste_exclus
#       @desk = Desk.where("route = '#{g}'").take
#       draw.each do |h|
#         Draw.create(:name => h.gsub(/_/, ' '), :route => h, :publish => userpub[j], :desk_id => @desk.id)
#         fiche = Dir.entries("./public/folders/#{f}/#{g}/#{h}")
#         fiche = fiche - liste_exclus
#         @draw = Draw.where("route = '#{h}'").take
#         fiche.each do |i|
#           if File.extname(i.to_s) == ".yt"
#             file = File.open("./public/folders/#{f}/#{g}/#{h}/#{i}", "r")
#               data = file.read
#             file.close
#             Fiche.create(:name => i.gsub(/_/, ' ').chomp(File.extname(i.to_s)), :route => data, :genre => File.extname(i.to_s), :publish => userpub[j], :draw_id => @draw.id)
#           else
#             Fiche.create(:name => i.gsub(/_/, ' ').chomp(File.extname(i.to_s)), :route => i, :genre => File.extname(i.to_s), :publish => userpub[j], :draw_id => @draw.id)
#           end
#         end
#       end
#   end
#   j = j + 1
# end
#
# FIN Remplissage de Desk Draw Fiche sur la base de folders existants
#

if Palette.count == 0
	Palette.create(:ref => "1", :c1 => "FF5B2B", :c2 => "B1221C", :c3 => "34393E", :c4 => "8CC6D7", :c5 => "FFDA8C")
	Palette.create(:ref => "2", :c1 => "850043", :c2 => "0B3A6F", :c3 => "00927B", :c4 => "006360", :c5 => "000000")
	Palette.create(:ref => "3", :c1 => "697EBD", :c2 => "F0D946", :c3 => "B1568C", :c4 => "579466", :c5 => "2F348B")
	Palette.create(:ref => "4", :c1 => "8CABBF", :c2 => "5E727F", :c3 => "BBE4FF", :c4 => "2F3940", :c5 => "A8CDE5")
	Palette.create(:ref => "5", :c1 => "45CCFF", :c2 => "49E83E", :c3 => "FFD432", :c4 => "E84B30", :c5 => "B243FF")
	Palette.create(:ref => "6", :c1 => "694137", :c2 => "5F4F38", :c3 => "94764E", :c4 => "A35143", :c5 => "AA474B")
	Palette.create(:ref => "7", :c1 => "00B79A", :c2 => "2D00FF", :c3 => "FF0000", :c4 => "E8A30C", :c5 => "5FFF0D")
	Palette.create(:ref => "8", :c1 => "9A896D", :c2 => "A49476", :c3 => "816F4D", :c4 => "836745", :c5 => "644C30")
	Palette.create(:ref => "9", :c1 => "424B5F", :c2 => "3B6169", :c3 => "597074", :c4 => "E0D289", :c5 => "DB3D37")
end

if Polices.count == 0
	Polices.create(:ref => "1", :nom => "Lato")
	Polices.create(:ref => "2", :nom => "Indie Flower")
	Polices.create(:ref => "3", :nom => "Baloo")
	Polices.create(:ref => "4", :nom => "Bree Serif")
end

if Image.count == 0
	Image.create(:ref => "1", :nom => "")
	Image.create(:ref => "2", :nom => "bandeau_music.jpg")
	Image.create(:ref => "3", :nom => "bandeau_cahier.jpg")
	Image.create(:ref => "4", :nom => "bandeau_batterie.jpg")
	Image.create(:ref => "5", :nom => "bandeau_flash.jpg")
	Image.create(:ref => "6", :nom => "bandeau_geo.jpg")
	Image.create(:ref => "7", :nom => "bandeau_traduction.jpg")
	Image.create(:ref => "8", :nom => "bandeau_litterature.jpg")
	Image.create(:ref => "9", :nom => "bandeau_math.jpg")
	Image.create(:ref => "10", :nom => "bandeau_piano.jpg")
	Image.create(:ref => "11", :nom => "bandeau_saxo.jpg")
	Image.create(:ref => "12", :nom => "bandeau_sport.jpg")
	Image.create(:ref => "13", :nom => "bandeau_techno.jpg")
	Image.create(:ref => "14", :nom => "bandeau_violon.jpg")
  Image.create(:ref => "15", :nom => "bandeau_notation.jpg")
end

if Layout.count == 0
	Layout.create(:ref => "1", :margin => "20px", :minwidth => "250px", :radius => "5px")
	Layout.create(:ref => "2", :margin => "0", :minwidth => "320px", :radius => "0")
	Layout.create(:ref => "3", :margin => "20px", :minwidth => "250px", :radius => "30px")
end
