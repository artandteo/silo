  Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#accueil'

  devise_for :users, path: '', path_names: { sign_in: 'connexion', sign_out: 'deconnexion', sign_up: 'inscription'}

  #==============================================================
  #                           DESK
  #==============================================================
  get '/:desk', to: 'application#desk', as: :desk
  post '/:desk', to: 'application#desk_add'
  delete '/:desk', to: 'application#eleve_delete'
  #==============================================================
  #                            DRAW
  #==============================================================
  get '/:desk/:draw', to: 'application#draw', as: :draw
  put '/:desk', to: 'application#draw_rename'
  post '/:desk/:draw',to: 'application#draw_add'
  delete '/:desk/:draw', to: 'application#draw_delete'
  #==============================================================
  #                            FOLDER
  #==============================================================
  get '/:desk/:draw/:folder', to: 'application#draw', as: :folder
  post '/:desk/:draw/:folder',to: 'application#folder_add'
  put '/:desk/:draw/:folder', to: 'application#folder_rename'
  delete '/:desk/:draw/:folder', to: 'application#folder_delete'
  #==============================================================
  #                        FILES MANAGEMENT
  #==============================================================
  put '/:desk/:draw/:folder/:file', to: 'application#file_rename', :constraints => { :file => /.*/ }
  get '/:desk/:draw/:folder/:file', to: 'application#draw', :constraints => { :file => /.*/ }, as: :files
  delete '/:desk/:draw/:folder/:file', to: 'application#file_delete', :constraints => { :file => /.*/ }
end
