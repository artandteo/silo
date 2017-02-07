class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :configure_devise_parameters, if: :devise_controller?
  before_action :authenticate_user!, only: [:index]

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    { :locale => I18n.locale == I18n.default_locale ? nil : I18n.locale  }
  end

  def accueil
    if user_signed_in?
      redirect_to desk_path(current_user.name)
    end
  end

  def desk
    if params[:desk] == current_user.name
      liste_rep("./public/folders/#{current_user.name}/")
    else
      #redirect_to desk_path(current_user.name)
    end
  end

  def draw
    liste_rep("./public/folders/#{current_user.name}/#{params[:draw]}/")
  end

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
  end

  private 

  def liste_rep(folder)
    d = Dir.open(folder)
    liste_exclus = [".", ".."]
    liste_dir = d.sort - liste_exclus

    i = 0
    @arr = Array.new
    liste_dir.each do |fichier|
      if File.ftype(folder+fichier) == "directory"
        @arr[i] = fichier
        i = i + 1
      end
    end
  end

  def liste_fichiers(folder)
    
  end

end
