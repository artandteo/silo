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
      redirect_to user_space_path(current_user.name)
    end
  end

  def desk
    if params[:directory] == current_user.name

    else
      redirect_to user_space_path(current_user.name)
    end
  end

  def draw 
    
  end

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
  end
end
