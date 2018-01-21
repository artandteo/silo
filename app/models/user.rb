class User < ApplicationRecord

  attr_accessor :login


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable

  validates :password, length: { minimum: 6, message: " doit être plus grand (6 caratères minimum)" }, on: :create
  validates :password, length: { minimum: 6, message: " doit être plus grand (6 caratères minimum)" }, on: :update, allow_blank: true
  validates_confirmation_of :password, on: :update, allow_blank: true

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
    @last.update_attribute(:nom, @last.nom.to_s.gsub(/\s+/, '_'))
    @last.update_attribute(:is_admin, 1)
    if !Dir.exists?(File.join("./public/folders/", @last.nom))
      Dir.mkdir(File.join("./public/folders/", @last.nom), 0777)
      @compte = Compte.new(nom: @last.nom, user_id: @last.id, titre_espace: "Mon Silo")
      @compte.save
      @preference = Preference.new(:polices => "1", :img_header => "", :color1 => "FF5B2B", :color2 => "B1221C", :color3 => "34393E", :color4 => "BCV6D7", :color5 => "FFDA8C",  :layout => "1", :compte_id => @compte.id)
      @preference.save
    end
  end

  private
end
