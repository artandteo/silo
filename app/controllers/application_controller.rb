class ApplicationController < ActionController::Base 
  protect_from_forgery with: :exception 

  def accueil
  end

  def inscription
  	redirect_to new_user_registration_path
  end
end
