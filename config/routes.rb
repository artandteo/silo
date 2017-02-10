Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#accueil'

    	devise_for :users, path: '', path_names: { sign_in: 'connexion', sign_out: 'deconnexion', sign_up: 'inscription'}


  get '/:desk', to: 'application#desk', as: :desk
  post '/:desk', to: 'application#desk_add'
  put '/:desk', to: 'application#desk_rename'
  delete '/:desk/:draw', to: 'application#desk_delete'

  get '/:desk/:draw/:source/:file', to: 'application#draw', :constraints => { :file => /.*/ }, as: :delete_file
  put '/:desk/:draw/:source/:file', to: 'application#file_rename', :constraints => { :file => /.*/ }
  delete '/:desk/:draw/:source/:file', to: 'application#file_delete', :constraints => { :file => /.*/ }

  put '/:desk/:draw', to: 'application#draw_rename'

  get '/:desk/:draw', to: 'application#draw', as: :draw
  get '/:desk/:draw/:dossier', to: 'application#draw', as: :draws
  post '/:desk/:draw',to: 'application#draw_add'
  
end
