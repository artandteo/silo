Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#accueil'

  get '/:desk', to: 'application#desk', as: :desk
  get '/:desk/:draw', to: 'application#draw', as: :draw

  scope "/(:locale)" do
  	devise_for :users, path: '', path_names: { sign_in: 'connexion', sign_out: 'deconnexion', sign_up: 'inscription'}
  end
  
end
