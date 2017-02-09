class User < ApplicationRecord

  has_one :preferences

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  def after_sign_up
  	puts "on rempli les prefs"
  end

  def after_confirmation
  	@last = User.last
  	Dir.mkdir(File.join("./public/folders/", @last.name), 0777)

    @compte = Compte.new(nom: @last.name, users_id: @last.id)
    @compte.save
  	@preference = Preference.new(:polices => "1", :img_header => "", :color1 => "FF5B2B", :color2 => "B1221C", :color3 => "34393E", :color4 => "BCV6D7", :color5 => "FFDA8C", :color6 => "FFFFFF", :comptes_id => @compte.id)
  	@preference.save
  end

end
