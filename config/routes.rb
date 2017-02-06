Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#accueil'

  scope "/(:locale)" do
  	devise_for :users, path: '', path_names: { sign_in: 'connexion', sign_out: 'deconnexion', sign_up: 'inscription'}

  	get '/:directory', to: 'application#desk', as: :user_space

  end
  
end
