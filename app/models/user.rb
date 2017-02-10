class User < ApplicationRecord

  # belongs_to :compte
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  def after_confirmation
  	@last = User.last
  	Dir.mkdir(File.join("./public/folders/", @last.nom), 0777)

    @compte = Compte.new(nom: @last.nom, user_id: @last.id)
    @compte.save
  	@preference = Preference.new(:polices => "1", :img_header => "", :color1 => "FF5B2B", :color2 => "B1221C", :color3 => "34393E", :color4 => "BCV6D7", :color5 => "FFDA8C",  :compte_id => @compte.id)
  	@preference.save
  end

end
