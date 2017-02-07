class ApplicationController < ActionController::Base 
  protect_from_forgery with: :exception 
  before_action :set_locale
  before_action :configure_devise_parameters, if: :devise_controller?
  before_action :authenticate_user!, only: [:index]
  before_action :liste_rep, only:[:desk]



  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    { :locale => I18n.locale == I18n.default_locale ? nil : I18n.locale  }
  end

  def accueil
    if user_signed_in?
      redirect_to user_space_path(current_user.name)
    end
  end

  def desk
    if params[:directory] == current_user.name
      puts "====== AFFICHAGE"
      @r = liste_rep

    else
      redirect_to user_space_path(current_user.name)
    end
  end

  def draw 
    
  end

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
  end

  def liste_rep()
    selfs = "./public/folders/#{current_user.name}/"

    d = Dir.open("./public/folders/#{current_user.name}/")
    liste_exclus = [".", ".."]
    liste_dir = d.sort - liste_exclus

    liste_dir.each do |fichier|
      
      if File.ftype(selfs+fichier) == "directory"
        puts "====== LISTE_REP"
        @directory = fichier
        puts @directory
      end
    end
  end
end
