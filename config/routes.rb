Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#accueil'

    	devise_for :users, path: '', path_names: { sign_in: 'connexion', sign_out: 'deconnexion', sign_up: 'inscription'}


  get '/:desk', to: 'application#desk', as: :desk
  post '/:desk', to: 'application#desk_add'
  delete '/:desk/:draw', to: 'application#desk_delete', as: :delete_desk

  get '/:desk/:draw', to: 'application#draw', as: :draw
  post '/:desk/:draw',to: 'application#draw_add'
  
end
