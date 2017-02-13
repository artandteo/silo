class User < ApplicationRecord

  attr_accessor :login


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable

  validates :identifiant_eleve, uniqueness: true, presence: true, on: :desk_add

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where("lower(identifiant_eleve) = :value OR lower(email) = :value", value: login.downcase).first
    else
      where(conditions.to_hash).first
    end
  end

  def after_confirmation
  	@last = User.last
  	Dir.mkdir(File.join("./public/folders/", @last.nom), 0777)

    @compte = Compte.new(nom: @last.nom, user_id: @last.id)
    @compte.save
  	@preference = Preference.new(:polices => "1", :img_header => "", :color1 => "FF5B2B", :color2 => "B1221C", :color3 => "34393E", :color4 => "BCV6D7", :color5 => "FFDA8C",  :compte_id => @compte.id)
  	@preference.save
  end
end
