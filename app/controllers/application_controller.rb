class ApplicationController < ActionController::Base
  require 'find'
  # require "google_drive"

  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :configure_devise_parameters, if: :devise_controller?
  before_action :authenticate_user!, only: [:desk, :draw, :desk_add, :desk_rename, :draw_add, :draw_rename]

  before_action :liste_eleves, only: [:mentions, :desk, :draw]

  before_action :palettes, :polices, :layouts, :images, :desk_size, only: [:mentions, :desk, :draw, :desk_add, :draw_add]
  before_action :load_pref, :config_pref


  helper_method :is_PDF?, :is_MP3?, :is_JPG?, :get_extension

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    { :locale => I18n.locale == I18n.default_locale ? nil : I18n.locale  }
  end

  def mentions
    # Creates a session. This will prompt the credential via command line for the
    # first time and save it to config.json file for later usages.
    # See this document to learn how to create config.json:
    # https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md
    # session = GoogleDrive::Session.from_config("config.json")

    # Gets list of remote files.
    # session.files.each do |file|
    #  p file.title
    # end

    # Uploads a local file.
    # session.upload_from_file("./public/img/logo_silo.png", "logo_silo.png", convert: false)

    # Downloads to a local file.
    # file = session.file_by_title("hello.txt")
    # file.download_to_file("/path/to/hello.txt")

    # Updates content of the remote file.
    # file.update_from_file("/path/to/hello.txt")
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
      liste_d("./public/folders/#{params[:desk]}/")
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
      
      @eleve = User.new(eleve_params)
      @eleve.nom = current_user.nom
      @eleve.is_admin = false
      @eleve.confirmed_at = DateTime.now.to_date
      @eleve.created_at = DateTime.now.to_date

      if User.exists?(identifiant_eleve: params[:eleve][:identifiant_eleve])
        flash[:alert] = 'User existe !'
        redirect_to :back
      elsif params[:eleve][:identifiant_eleve].blank?
        flash[:alert] = "L'élève doit avoir un identifiant !"
        redirect_to :back
      elsif params[:eleve][:password].blank?
        flash[:alert] = 'Le mot de passe est obligatoire !'
        redirect_to :back
      else
        @eleve.save
        flash[:success] = "L'utilisateur a été crée !"
        redirect_to :back
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
      desk = params[:nouv_desk][:nom].to_s.gsub(/\s+/, '_')
      path = "./public/folders/#{params[:desk]}/"
      if !Dir.exists?(File.join(path, desk))
        Dir.mkdir(File.join(path, desk), 0777)
        redirect_to desk_path
      else
        flash[:alert] = 'Le nom de dossier existe déjà !'
        redirect_to :back
      end
    end
  end

  def desk_size
    if user_signed_in? && current_user.is_admin?
      size = 0
      path = "./public/folders/#{current_user.nom}/"
      Dir.glob(File.join(path, '**', '*')) { |file| size+=File.size(file) }

      ko = size / 1024
      mo = ko.round(2) / 1024
      @total = mo / 500 * 100
      @mo_used = mo
      @mo_used = mo.round(2)
      @total = @total.round
    end
  end

#==============================================================
#                     DRAW
#==============================================================
  # Affichage des draw
  # Route : GET/:desk/:draw
  def draw
      @table = Array.new { Array.new }
      @data_arr = Array.new
      @table_videos = Array.new { Array.new }
      @breadcrumb = params[:draw]
      i = 0
      liste_d("./public/folders/#{current_user.nom}/#{params[:draw]}/").each do |a|
        b = liste_f("./public/folders/#{current_user.nom}/#{params[:draw]}/#{a}/")
        if b.include?("videos.txt")
          file=File.open("public/folders/#{current_user.nom}/#{params[:draw]}/#{a}/videos.txt", "r")
          data = file.read
          file.close
          @data_arr = data.split(';')
          #@data_arr.each {|ev| puts('-'+ev)}
          b.delete("videos.txt")
          @table.push(b)
          @table_videos.push(@data_arr)
        else
          @table.push(b)
          @table_videos.push(@data_arr)
        end
        @length = @table.length
      i = i + 1
      end

      #liste_d("./public/folders/#{current_user.nom}/#{params[:draw]}/")
      #liste_f("./public/folders/#{current_user.nom}/#{params[:draw]}/")

  end

  # Ajouter un draw
  # Route : POST/:desk/:draw
  def draw_add
    # Liens Youtube #
    if params.include?(:nouv_youtube)
      titre = params[:nouv_youtube][:titre]
      lien = params[:nouv_youtube][:nom].sub("watch?v=", "embed/")
      lien = lien.sub("https", "http")
      file = File.open("public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:dossier_courant]}/videos.txt", "a")
        file.write(titre+';'+lien+';')
      file.close
      redirect_to :back
    end

    # Nouveau dossier #
    if params.include?(:nouv_dossier)
      draw = params[:nouv_dossier][:nom].to_s.gsub(/\s+/, '_')
      path = "./public/folders/#{params[:desk]}/#{params[:draw]}/"
      if !Dir.exists?(File.join(path, draw))
        Dir.mkdir(File.join(path, draw), 0777)
        redirect_to draw_path(current_user.nom)
      else
        flash[:alert] = 'Le dossier existe déjà !'
        redirect_to :back
      end
    end

    # Nouveau fichier #
    if params.include?(:fichiers)
      authorized_ext = [".pdf", ".jpg", ".jpeg", ".mp3"]
      params[:fichiers].each do |file|
        filename = file.original_filename
        directory = "public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:dossier_courant]}/"
        path = File.join(directory, filename)
        Dir[File.join("public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:dossier_courant]}/", '**', '*')].count
        if authorized_ext.include? File.extname(path)
          if file.size <= 2097152
            if Dir[File.join("public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:dossier_courant]}/", '**', '*')].count != 25
              File.open(path, "wb") { |f| f.write(file.read) }
              flash[:success] = 'Fichier téléchargé'
              redirect_to :back
            else
              flash[:danger] = "Limite de fichier atteinte !"
            end
          else
            flash[:danger] = "La taille du fichier doit être inférieur ou égale à 2mo !"
          end
        else
          flash[:alert] = 'Extension non autorisé'
        end
      end 
    end   
  end

  # Renommer le nom d'un draw
  # Route : PUT/:desk/:draw
  def draw_rename
    #-------------------------------------------
    #          TRAITEMENT DU FORMULAIRE
    #            RENOMMER SON ESPACE
    #-------------------------------------------
    if params.include?(:nom_espace)
      @last_name = current_user.nom
      @new_name = params[:nom_espace][:nom].to_s.gsub(' ', '_')
      # Mise à jour du titre de l'espace
      if params[:nom_espace][:nom].blank? && !params[:nom_espace][:titre].blank?
        if params[:nom_espace][:nom].length <= 60
          @compte = Compte.where(user_id: current_user.id).take
          @compte.update(titre_espace: params[:nom_espace][:titre])
          flash[:success] = "Le titre de l'espace a été sauvegardé."
          redirect_to :back
        else 
          flash[:danger] = "Le nombre de caractères maximum dooit être de 60."
          redirect_to :back
        end

      # Mise à jour du nom de dossier
      else
        if !params[:nom_espace][:nom].blank? && !params[:nom_espace][:titre].blank?
          if params[:nom_espace][:nom].length <= 20
            if params[:nom_espace][:nom].length <= 60
              if !Dir.exists?("./public/folders/#{@new_name}")
                puts "======= UPDATE ============="
                if current_user.update_attribute(:nom, @new_name)

                  FileUtils.mv("./public/folders/#{params[:desk]}", "./public/folders/#{@new_name}")
                  @eleves = User.where(nom: @last_name)
                  puts current_user.nom
                  @eleves.each do |e|
                    e.update_attribute(:nom, @new_name)
                  end
                  @compte = Compte.where(user_id: current_user.id).take
                  @compte.update(nom: @new_name, titre_espace: params[:nom_espace][:titre])
                  flash[:success] = "Votre espace a bien été renommé !"
                  redirect_to desk_path
                end
              else
                flash[:danger] = "Le nom de l'espace existe déjà !"
                redirect_to :back
              end
            else
              flash[:danger] = "Le nombre de caractères maximum dooit être de 60."
              redirect_to :back
            end
          else 
            flash[:danger] = "Le nombre de caractères maximum doit être de 20."
          end
        else 
          flash[:danger] = "Le titre de l'espace ne doit pas être rempli !"
          redirect_to :back
        end
      end
    end

    if params.include?(:rename)
      draw = params[:rename][:new_name].to_s.gsub(' ', '_')
      puts draw
      if !Dir.exists?("./public/folders/#{current_user.nom}/#{draw}")
        FileUtils.mv("./public/folders/#{current_user.nom}/#{params[:rename][:last_name]}", "./public/folders/#{current_user.nom}/#{draw}")
        redirect_to :back
      else
        flash[:alert] = 'Le dossier existe déjà, impossible de renommer'
        redirect_to :back
      end
    end
  end

  # Supprimer un desk
  def draw_delete
      if Dir.exists?("./public/folders/#{params[:desk]}/#{params[:draw]}")
        FileUtils.rm_rf("./public/folders/#{params[:desk]}/#{params[:draw]}")
        redirect_to desk_path
      else
        flash[:alert] = 'Le dossier n\'existe pas !'
        redirect_to :back
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
    folder = params[:renommer_folder][:new_name].to_s.gsub(' ', '_')
    if !Dir.exists?("./public/folders/#{current_user.nom}/#{params[:draw]}/#{folder}")
      FileUtils.mv("./public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:renommer_folder][:last_name]}", "./public/folders/#{current_user.nom}/#{params[:draw]}/#{folder}")
      flash[:success] = 'Votre dossier a bien été renommé'
      redirect_to :back
    else
      flash[:alert] = 'Une erreur s\'est produite'
      redirect_to :back
    end
  end

  # Suppresion d'un fichier
  # Route : DELETE/:desk/:draw/:folder/:file
  def file_delete
    file = "./public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:folder]}/#{params[:file]}"
    File.delete(file) if File.exist?(file)
    flash[:success] = 'Votre fichier a bien été supprimé'
    redirect_to draw_path
  end

  # Renommer un fichier
  # Route : PUT/:desk/:draw/:folder/:file
  def file_rename
    filename = "#{params[:file_rename][:new_filename]}#{get_extension(params[:file_rename][:last_filename])}"
    if !File.exist?("./public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:folder]}/#{filename}")
      FileUtils.mv("./public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:folder]}/#{params[:file_rename][:last_filename]}", "./public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:folder]}/#{filename}")
      flash[:success] = 'Votre fichier a bien été renommé'
      redirect_to draw_path
    else
      flash[:alert] = 'Un fichier avec le même nom existe déjà !'
      redirect_to :back
    end
  end

  def is_PDF?(file)
    File.extname(file.to_s) == ".pdf"
  end

  def is_JPG?(file)
    authorized_ext = [".jpg", ".jpeg"]
    authorized_ext.include? File.extname(file)
  end

  def is_MP3?(file)
    File.extname(file.to_s) == ".mp3"
  end

  def get_extension(file)
    File.extname(file.to_s)
  end
#==============================================================
#                     ELEVES
#==============================================================

  # Affiche la liste des elèves
  def liste_eleves
      if user_signed_in? && current_user.is_admin?
        # Liste des élèves d'un professeur
        @eleves = User.where(nom: current_user.nom).where.not(identifiant_eleve: nil)
      end
  end

  def eleve_delete
    if params.include?(:hidden)
      User.destroy(params[:mesEleves])
      flash[:success] = 'Utilisateur effacé'
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
  #                     VIDEOS
  #==============================================================
  def video
    if params.include?(:titre_rename)
      puts "rename"
      puts params[:video]
    else
      # suppresion
      puts "suppresion"
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
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:nom, :email, :password, :is_admin) }
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
    liste_exclus = [".", "..", ".DS_Store"]
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
