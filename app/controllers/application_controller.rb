class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :configure_devise_parameters, if: :devise_controller?
  before_action :authenticate_user!, only: [:desk, :draw, :desk_add, :desk_rename, :draw_add, :draw_rename]
  
  before_action :liste_eleves, only: [:desk, :draw]

  before_action :palettes, :polices, :layouts, :images, only: [:desk, :draw, :desk_add, :draw_add]
  before_action :load_pref, :config_pref

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    { :locale => I18n.locale == I18n.default_locale ? nil : I18n.locale  }
  end

  def accueil
    if user_signed_in?
      redirect_to desk_path(current_user.nom)
    end
  end

#==============================================================
#                     DESK
#==============================================================
  # Affichage des desks
  def desk
    if params[:desk] == current_user.nom
      liste_d("./public/folders/#{current_user.nom}/")
    else
      redirect_to desk_path(current_user.nom)
    end
  end

  def desk_add
    #-------------------------------------------
    #          TRAITEMENT DU FORMULAIRE
    #             AJOUT D'UN ELEVE
    #-------------------------------------------
    if params.include?(:eleve)
      @user = User.exists?(identifiant_eleve: params[:eleve][:identifiant_eleve])

      @eleve = User.new(eleve_params)
      @eleve.nom = current_user.nom
      @eleve.is_admin = false
      @eleve.confirmed_at = DateTime.now.to_date
      @eleve.created_at = DateTime.now.to_date

      if !@user && !params[:eleve][:password].empty?
        @eleve.save
        redirect_to :back
      else
        redirect_to :back, notice: "Une erreur est survenue !"
      end
      #if @eleve.identifiant_eleve == 
        #@eleve.save
        #redirect_to :back
      #end
      #@eleve = User.new(:email => "", :created_at => DateTime.now.to_date, :nom => current_user.nom, :identifiant_eleve => params[:identifiant_eleve], :is_admin => false)
      #puts @eleve.inspect
      #@eleve.save
    end
    #-------------------------------------------
    #          TRAITEMENT DU FORMULAIRE
    #             AJOUT D'UN DESK
    #-------------------------------------------
    if params.include?(:nouv_desk)

      path = "./public/folders/#{params[:desk]}/"
      if !Dir.exists?(File.join(path, params[:nouv_desk][:nom]))
        Dir.mkdir(File.join(path, params[:nouv_desk][:nom]), 0777)
        redirect_to desk_path
      else 
        redirect_to :back, notice: "Le nom de dossier existe déjà !"
      end
    end
  end

#==============================================================
#                     DRAW
#==============================================================
  # Affichage des draw
  # Route : GET/:desk/:draw
  def draw
      @table = Array.new { Array.new }
      @breadcrumb = params[:draw]
      i = 0
      liste_d("./public/folders/#{current_user.nom}/#{params[:draw]}/").each do |a|

        b = liste_f("./public/folders/#{current_user.nom}/#{params[:draw]}/#{a}/")
        @table.push(b)
        @length = @table.length
      i = i + 1
      end

      liste_d("./public/folders/#{current_user.nom}/#{params[:draw]}/")
      liste_f("./public/folders/#{current_user.nom}/#{params[:draw]}/")

  end

  # Ajouter un draw
  # Route : POST/:desk/:draw
  def draw_add
    if params.include?(:nouv_dossier)
      path = "./public/folders/#{params[:desk]}/#{params[:draw]}/"
      if !Dir.exists?(File.join(path, params[:nouv_dossier][:nom]))
        Dir.mkdir(File.join(path, params[:nouv_dossier][:nom]), 0777)
        redirect_to draw_path(current_user.nom)
      else
        redirect_to :back, notice: "Le dossier existe déjà !"
      end
    else
      authorized_ext = [".pdf", ".jpg", ".jpeg", ".mp3"]
      if params.include?(:nouv_fichier) && !params[:nouv_fichier][:fichier].blank?
        filename = params[:nouv_fichier][:fichier].original_filename
        directory = "public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:nouv_fichier][:dossier_courant]}/"
        path = File.join(directory, filename)
        if authorized_ext.include? File.extname(path)
          File.open(path, "wb") { |f| f.write(params[:nouv_fichier][:fichier].read) }
          redirect_to draw_path, notice: 'Fichier téléchargé'
        else
          redirect_to draw_path, notice: 'extension non autorisé'
        end
      else
        redirect_to draw_path, notice: 'Aucun fichier téléchargé'
      end
    end
  end

  # # Renommer le nom d'un desk
  # def draw_rename
  #   if params.include?(:rename)
  #     FileUtils.mv("./public/folders/#{current_user.nom}/#{params[:rename][:last_name]}", "./public/folders/#{current_user.nom}/#{params[:rename][:new_name]}")
  #     redirect_to desk_path
  #   end
  #   #-------------------------------------------
  #   #          TRAITEMENT DU FORMULAIRE
  #   #             EDITION D'UN ELEVE
  #   #-------------------------------------------
  #   if params.include?(:eleve)
  #     @eleve = User.where(identifiant_eleve: params[:eleve][:ancien_nom]).take
  #     @eleve.update(identifiant_eleve: params[:eleve][:identifiant_eleve])
  #     redirect_to :back
  #   end
  # end

  # Renommer le nom d'un draw
  # Route : PUT/:desk/:draw
  def draw_rename
    if !Dir.exists?("./public/folders/#{current_user.nom}/#{params[:rename][:new_name]}")
      FileUtils.mv("./public/folders/#{current_user.nom}/#{params[:rename][:last_name]}", "./public/folders/#{current_user.nom}/#{params[:rename][:new_name]}")
      redirect_to :back
    else 
      redirect_to :back, notice: "Le dossier existe déjà, impossible de renommer"
    end
  end

  # Supprimer un desk
  def draw_delete
      if Dir.exists?("./public/folders/#{params[:desk]}/#{params[:draw]}")
        FileUtils.rm_rf("./public/folders/#{params[:desk]}/#{params[:draw]}")
        redirect_to desk_path
      else
        redirect_to :back, notice: "Le dossier n'existe pas !"
      end
  end

  #==============================================================
  #                     FOLDERS
  #==============================================================
  # Supprimer un folder situé dans un draw
  # Route : DELETE/:desk/:draw/:folder
  def folder_delete
    FileUtils.rm_rf("./public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:folder]}")
    redirect_to :back
  end

  # Renommer le nom d'un folder
  # Route : PUT/:desk/:draw
  def folder_rename
    if !Dir.exists?("./public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:renommer_folder][:new_name]}")
      FileUtils.mv("./public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:renommer_folder][:last_name]}", "./public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:renommer_folder][:new_name]}")
      redirect_to :back
    else
      redirect_to :back, notice: "le dossier existe déjà, impossible de renommer"
    end
  end

  # Suppresion d'un fichier
  # Route : DELETE/:desk/:draw/:folder/:file
  def file_delete
    file = "./public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:folder]}/#{params[:file]}"
    File.delete(file) if File.exist?(file)
    redirect_to draw_path
  end

  # Renommer un fichier
  # Route : PUT/:desk/:draw/:folder/:file
  def file_rename

    if !File.exist?("./public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:folder]}/#{params[:file_rename][:new_filename]}")
      FileUtils.mv("./public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:folder]}/#{params[:file_rename][:last_filename]}", "./public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:folder]}/#{params[:file_rename][:new_filename]}")
      redirect_to draw_path
    else 
      redirect_to :back, notice: "Un fichier avec le même nom existe déjà !"
    end
  end

#==============================================================
#                     ELEVES
#==============================================================

  # Affiche la liste des elèves
  def liste_eleves
      # Liste des élèves d'un professeur
      @eleves = User.where(nom: current_user.nom).where.not(identifiant_eleve: nil)
  end

  def eleve_delete
    if params.include?(:hidden)
      User.destroy(params[:mesEleves])
      redirect_to :back
    end
  end

  # Chargement des palettes
  def palettes
    @palette = Palette.all
  end

  # Chargement des polices
  def polices
    @police = Polices.all
  end

  # Chargement des layouts
  def layouts
    @layouts = Layout.all
  end

  # Chargement des images
  def images
    @image = Image.all
  end

  # Chargement des préférences
  def liste_eleves
    @eleves = User.where(nom: current_user.nom).where.not(identifiant_eleve: nil)
  end

  def load_pref
    if user_signed_in?
      @compte = Compte.where(nom: current_user.nom).take
      @pref = Preference.where(compte_id: @compte).take
      @layout = Layout.where(ref: @pref.layout).take
    end
  end

  # Configuration des préférences
  def config_pref
    if params.include?(:preferences)
      @palette = Palette.where(ref: params[:preferences][:color]).take
      @police = Polices.where(ref: params[:preferences][:police]).take
      @layout = Layout.where(ref: params[:preferences][:layout]).take
      @image = Image.where(ref: params[:preferences][:image]).take
      @compte = Compte.where(user_id: current_user.id)
      @pref = Preference.where(compte_id: @compte).take
      if @police != nil
        @pref.update(polices: @police.nom)
      end
      if @palette != nil
        @pref.update(color1: @palette.c1, color2: @palette.c2, color3: @palette.c3, color4: @palette.c4, color5: @palette.c5)
      end
      if @layout != nil
        @pref.update(layout: @layout.ref)
      end
      if @image != nil
        @pref.update(img_header: @image.nom)
      end
      redirect_to :back
    end
  end

#==============================================================
#                     PRIVATE
#==============================================================

  private

  def eleve_params
      params.require(:eleve).permit(:identifiant_eleve, :password)
  end

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:nom, :email, :password, :password_confirmation, :is_admin) }
  end


  def liste_d(folder)
    d = Dir.open(folder)
    liste_exclus = [".", "..", ".DS_Store"]
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

  def liste_f(dir)
    d = Dir.open(dir)
    liste_exclus = [".", ".."]
    liste_dir = d.sort - liste_exclus

    a = 0
    @files = Array.new
    liste_dir.each do |fichier|
      if File.ftype(dir+fichier) == "file"
          @files[a] = fichier
          a = a + 1
      end
    end
  end

end
