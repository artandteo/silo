class ApplicationController < ActionController::Base
  require 'find'
  # require "google_drive"

  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :configure_devise_parameters, if: :devise_controller?
  before_action :authenticate_user!, only: [:desk, :draw, :desk_add, :desk_rename, :draw_add, :draw_rename]

  before_action :liste_eleves, only: [:mentions, :desk, :draw, :visi]

  before_action :palettes, :polices, :layouts, :images, :desk_size, only: [:mentions, :compte, :desk, :draw, :desk_add, :draw_add]
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
      # redirect_to silo_path(current_user.nom)
      redirect_to desk_path(current_user.nom)
    else
      redirect_to new_user_session_path
    end
  end

#==============================================================
#                     DESK
#==============================================================
  # Affichage des desks
  def desk
    if params[:desk] == current_user.nom
      @arr = Array.new
      @vis_elev = Array.new
      @eleves = Array.new
      @eleves = User.where(nom: current_user.nom).where.not(identifiant_eleve: nil)
      @desk = Desk.where(:compte_id => ccid(params[:desk])).all
      @desk = @desk.sort_by { |x| x[:rang] }
        @desk.each do |d|
          @arr << d.route
          @vis_elev << (d.publish)
        end
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
      @eleve.is_admin = 0
      @eleve.is_admin = 2 if params[:eleve][:is_admin] == "1"
      @eleve.confirmed_at = DateTime.now.to_date
      @eleve.created_at = DateTime.now.to_date
      @desk = Desk.where(:compte_id => ccid(params[:desk])).all
      @desk.each do |d|
        acces = d.publish
        Desk.update(d.id, :publish => (acces+"1"))
      end

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
    end
    #-------------------------------------------
    #          TRAITEMENT DU FORMULAIRE
    #             AJOUT D'UN DESK
    #-------------------------------------------
    if params.include?(:nouv_desk)
      desk = params[:nouv_desk][:nom].to_s.gsub(/\s+|'/, '_')
      path = "./public/folders/#{params[:desk]}/"
      if !Dir.exists?(File.join(path, desk))
        Dir.mkdir(File.join(path, desk), 0777)
        # ajout desk dans bdd
        @eleves = liste_eleves
        deskrang = Desk.where(:compte_id => ccid(params[:desk])).all
        rang = deskrang.length
        @desk = Desk.new(:name => params[:nouv_desk][:nom], :route => desk, :publish => ("1"*@eleves.count), :compte_id => ccid(params[:desk]), :rang => rang)
        @desk.save
        # FIN ajout desk dans bdd
        redirect_to desk_path
      else
        flash[:alert] = 'Le nom de dossier existe déjà !'
        redirect_to :back
      end
    end
  end

  def desk_size
    if user_signed_in? && current_user.is_admin == 1
      size = 0
      path = "./public/folders/#{current_user.nom}/"
      Dir.glob(File.join(path, '**', '*')) { |file| size+=File.size(file) }

      ko = size / 1024
      mo = ko.round(2) / 1024
      @total = mo / 2500 * 100
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
      @route = Array.new { Array.new }
      @genre = Array.new { Array.new }
      @data_arr = Array.new
      @arrdraw = Array.new
      @arrdrawname = Array.new
      @table_videos = Array.new { Array.new }
      @breadcrumb = params[:draw]

      compte = Compte.where(:nom => params[:desk]).take
      deskselect = Desk.where(:route => params[:draw], :compte_id => compte.id).take
      if draw_auth(deskselect) == false && current_user.is_admin == 0
        return head :forbidden
      end
      deskid = deskselect.id
      @draw = Draw.where(:desk_id => deskid).all
      @draw = @draw.sort_by { |x| x[:rang] }
        @draw.each do |a|
          @arrdraw << a.route
          @arrdrawname << a.name
          @fiche = Fiche.where(:draw_id => a.id).all
          @fiche = @fiche.sort_by { |x| x[:name] }
          @b = Array.new
          @c = Array.new
          @d = Array.new
            @fiche.each do |d|
              @b << d.name
              @c << d.route
              @d << d.genre
            end
              @table.push(@b)
              @route.push(@c)
              @genre.push(@d)
              @table_videos.push(@data_arr)
          @length = @table.length
        end
  end

  # Ajouter un draw
  # Route : POST/:desk/:draw
  def draw_add
    # Liens Youtube #
    if params.include?(:nouv_youtube)
      titre = params[:nouv_youtube][:titre]
      lien = URI.escape(params[:nouv_youtube][:nom]).sub("watch?v=", "embed/")
      if lien[0..23] != "https://www.youtube.com/"
        flash[:alert] = 'Attention, ce lien n\'est pas un chemin youtube.'
      else
        # lien = lien.sub("https", "http")
        # traitement dans bdd
        nomdesk = params[:draw]
        currentdesk = Desk.where(:route => nomdesk, :compte_id => ccid(params[:desk])).take
        cdid = currentdesk.id
        nomdraw = params[:dossier_courant]
        currentdraw = Draw.where(:route => nomdraw, :desk_id => cdid.to_i ).take
        cdrid = currentdraw.id
        @fiche = Fiche.new(:name => titre, :route => lien, :genre => ".yt", :publish => true, :draw_id => cdrid.to_i)
        @fiche.save
        #FIN traitement dans bdd
        # Ecriture d'un fichier par vidéos
        file = File.open("public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:dossier_courant]}/#{titre}.yt", "a")
          file.write(lien)
        file.close
        # FIN Ecriture d'un fichier par vidéos
      end
      redirect_to :back
    end

    # Nouveau dossier #
    if params.include?(:nouv_dossier)
      draw = params[:nouv_dossier][:nom].to_s.gsub(/\s+|'/, '_')
      path = "./public/folders/#{params[:desk]}/#{params[:draw]}/"
      if !Dir.exists?(File.join(path, draw))
        Dir.mkdir(File.join(path, draw), 0777)
        # Nouveau dossier bdd
        nomdesk = params[:draw]
        currentdesk = Desk.where(:route => nomdesk, :compte_id => ccid(params[:desk])).take
        cdid = currentdesk.id
        drawrang = Draw.where(:desk_id => cdid).all
        rang = drawrang.length
        @draw = Draw.new(:name => params[:nouv_dossier][:nom], :route => draw, :publish => true, :desk_id => cdid.to_i, :rang => rang)
        @draw.save
        # FIN Nouveau dossier bdd
        redirect_to draw_path(current_user.nom)
      else
        flash[:alert] = 'Le dossier existe déjà !'
        redirect_to :back
      end
    end

    # Nouveau fichier #
    if params.include?(:fichiers)
      authorized_ext = [".pdf", ".jpg", ".jpeg", ".mp3", ".PDF", ".JPG", ".JPEG", ".MP3", ".dwg", ".DWG", ".doc", ".docx", ".xls", ".xlsx"]
      params[:fichiers].each do |file|
        if file.size <= 20480000
          puts "============ TEST FILE SIZE ==============="
          filename = file.original_filename
          directory = "public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:dossier_courant]}/"
          path = File.join(directory, filename)
          if !File.exist?(path)
          puts "============= TEST EXIST =================="
            Dir[File.join("public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:dossier_courant]}/", '**', '*')].count
            if authorized_ext.include? File.extname(path)
              puts "============ TEST FILE EXTENSION ==============="
              if Dir[File.join("public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:dossier_courant]}/", '**', '*')].count != 25
                puts "============ TEST FILE COUNT ==============="
                # flash[:success] = 'Veuillez patienter, fichier en téléchargement...'
                File.open(path, "wb") { |f| f.write(file.read) }
                # Nouveau fichier bdd
                nomdesk = params[:draw]
                currentdesk = Desk.where(:route => nomdesk, :compte_id => ccid(params[:desk])).take
                cdid = currentdesk.id
                nomdraw = params[:dossier_courant]
                currentdraw = Draw.where(:route => nomdraw, :desk_id => cdid.to_i ).take
                cdrid = currentdraw.id
                @fiche = Fiche.new(:name => filename, :route => filename, :genre => File.extname(path), :publish => true, :draw_id => cdrid.to_i)
                @fiche.save
                # FIN Nouveau fichier bdd

                flash[:success] = 'Fichier téléchargé'
              else
                flash[:danger] = "Limite de fichier atteinte !"
              end
            else
              flash[:alert] = 'Extension non autorisé'
            end
          else
              flash[:alert] = 'Le fichier '+filename+' est déjà présent dans cet onglet'
          end
        else
          flash[:danger] = "La taille du fichier doit être inférieur ou égale à 10mo !"
        end
      end
      redirect_to draw_path
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
      @new_name = params[:nom_espace][:nom].to_s.gsub(/\s+|'/, '_')
      # Mise à jour du titre de l'espace
      if params[:nom_espace][:nom].blank? && !params[:nom_espace][:titre].blank?
        if params[:nom_espace][:nom].length <= 60
          @compte = Compte.where(user_id: current_user.id, nom: @last_name).take
          @compte.update(titre_espace: params[:nom_espace][:titre])
          flash[:success] = "Le titre de l'espace a été sauvegardé."
          redirect_to :back
        else
          flash[:danger] = "Le nombre de caractères maximum doit être de 60."
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
              flash[:danger] = "Le nombre de caractères maximum doit être de 60."
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
      draw = params[:rename][:new_name].to_s.gsub(/\s+|'/, '_')
      if !Dir.exists?("./public/folders/#{current_user.nom}/#{draw}")
        FileUtils.mv("./public/folders/#{current_user.nom}/#{params[:rename][:last_name]}", "./public/folders/#{current_user.nom}/#{draw}")
        # renommer desk dans bdd
        deskren = Desk.where(:route => params[:rename][:last_name], :compte_id => ccid(params[:desk])).take
        deskrenid = deskren.id
        Desk.update(deskrenid, :name => params[:rename][:new_name], :route => draw)
        # FIN renommer desk dans bdd
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
        # suppression desk dans bdd
        Desk.where(:route => params[:draw], :compte_id => ccid(params[:desk])).destroy_all
        # FIN suppression desk dans bdd
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
    # suppression draw(folder, onglet) dans bdd
    nomdesk = params[:draw]
    currentdesk = Desk.where(:route => nomdesk, :compte_id => ccid(params[:desk])).take
    cdid = currentdesk.id
    Draw.where(:route => params[:folder], :desk_id => cdid).destroy_all
    # FIN suppression draw(folder, onglet) dans bdd
    redirect_to :back
  end

  # Renommer le nom d'un folder
  # Route : PUT/:desk/:draw
  def folder_rename
    folder = params[:renommer_folder][:new_name].to_s.gsub(/\s+|'/, '_')
    if !Dir.exists?("./public/folders/#{current_user.nom}/#{params[:draw]}/#{folder}")
      FileUtils.mv("./public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:renommer_folder][:last_name].to_s.gsub(/\s+|'/, '_')}", "./public/folders/#{current_user.nom}/#{params[:draw]}/#{folder}")
    end
      # renommer draw(folder, onglet) dans bdd
      nomdesk = params[:draw]
      currentdesk = Desk.where(:route => nomdesk, :compte_id => ccid(params[:desk])).take
      cdid = currentdesk.id
      drawren = Draw.where(:route => params[:renommer_folder][:last_name].to_s.gsub(/\s+|'/, '_'), :desk_id => cdid).take
      drawrenid = drawren.id
      Draw.update(drawrenid, :name => params[:renommer_folder][:new_name], :route => folder)
      # FIN renommer draw(folder, onglet) dans bdd
      flash[:success] = 'Votre dossier a bien été renommé'
      redirect_to :back
  end

  # Suppresion d'un fichier
  # Route : DELETE/:desk/:draw/:folder/:file
  def file_delete
    file = "./public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:folder]}/#{params[:file]}"
    File.delete(file) if File.exist?(file)
    # suppression fichier dans bdd
    nomdesk = params[:draw]
    currentdesk = Desk.where(:route => nomdesk, :compte_id => ccid(params[:desk])).take
    cdid = currentdesk.id
    currentdraw = Draw.where(:route => params[:folder], :desk_id => cdid).take
    cdrid = currentdraw.id
    if get_extension(params[:file]) == ".yt"
      Fiche.where(:name => params[:file].chomp(get_extension(params[:file])), :draw_id => cdrid).destroy_all
    else
      Fiche.where(:route => params[:file], :draw_id => cdrid).destroy_all
    end
    # FIN suppression fichier dans bdd
    flash[:success] = 'Votre fichier a bien été supprimé'
    redirect_to draw_path
  end

  # Renommer un fichier
  # Route : PUT/:desk/:draw/:folder/:file
  def file_rename
    filename = "#{params[:file_rename][:new_filename]}#{get_extension(params[:file_rename][:last_filename])}"
    if !File.exist?("./public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:folder]}/#{filename}")
      FileUtils.mv("./public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:folder]}/#{params[:file_rename][:last_filename]}", "./public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:folder]}/#{filename}")
      # renommer fichier dans bdd
      nomdesk = params[:draw]
      currentdesk = Desk.where(:route => nomdesk, :compte_id => ccid(params[:desk])).take
      cdid = currentdesk.id
      currentdraw = Draw.where(:route => params[:folder], :desk_id => cdid).take
      cdrid = currentdraw.id
      if get_extension(params[:file_rename][:last_filename]) == ".yt"
        ficheren = Fiche.where(:name => params[:file_rename][:last_filename].chomp('.yt'), :draw_id => cdrid).take
        ficherenid = ficheren.id
        Fiche.update(ficherenid, :name => params[:file_rename][:new_filename])
      else
        ficheren = Fiche.where(:route => params[:file_rename][:last_filename], :draw_id => cdrid).take
        ficherenid = ficheren.id
        Fiche.update(ficherenid, :name => filename, :route => filename)
      end
      # FIN renommer fichier dans bdd
      flash[:success] = 'Votre fichier a bien été renommé'
      redirect_to draw_path
    else
      flash[:alert] = 'Un fichier avec le même nom existe déjà !'
      redirect_to :back
    end
  end

  def is_PDF?(file)
    authorized_ext = [".pdf", ".PDF"]
    authorized_ext.include? File.extname(file)
  end

  def is_JPG?(file)
    authorized_ext = [".jpg", ".jpeg", ".JPG", "JPEG"]
    authorized_ext.include? File.extname(file)
  end

  def is_MP3?(file)
    authorized_ext = [".mp3",".MP3"]
    authorized_ext.include? File.extname(file)
  end

  def get_extension(file)
    File.extname(file.to_s)
  end

#==============================================================
#                     ELEVES
#==============================================================

  # Affiche la liste des elèves
  def liste_eleves
      if user_signed_in? && current_user.is_admin != 0
        # Liste des élèves d'un professeur
        @eleves = User.where(nom: current_user.nom).where.not(identifiant_eleve: nil)
      end
  end

  def eleve_delete
    if params.include?(:hidden)

      nomcompte = params[:desk].to_s.gsub(/\s+|'/, '_')
      currentcompte = Compte.where(:nom => nomcompte).take
      ccid = currentcompte.id
      @desk = Desk.where(:compte_id => ccid).all
      @eleves = liste_eleves
      @eleves_sel = params[:mesEleves]
      i = 0
      @eleves_sel.each do |es|
        @eleves.each do |e|
          if e.id == es.to_i
            @desk.each do |d|
              acces = d.publish
              acces[i] = ""
              Desk.update(d.id, :publish => acces)
            end
          end
        i = i + 1
        end
      end

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
      @compte = Compte.where(user_id: current_user.id, nom: params[:desk])
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
      # rename
      file = File.open("public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:folder]}/videos.txt", "r")
        data = file.read
      file.close
      data = data.split(';')
      @titre_r = params[:video]
      @new_titre = params[:titre_rename][:new_titre]
      i = 0
      data.each do |e|
        if e == @titre_r
           data[i] = @new_titre
        end
        i = i + 1
      end
      data = data * ";"
      file = File.open("public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:folder]}/videos.txt", "w")
        file.write(data)
      file.close
      redirect_to :back
    else
      # suppresion
      file = File.open("public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:folder]}/videos.txt", "r")
        data = file.read
      file.close
      data = data.split(';')
      @titre_d = params[:video]
      i = 0
      data.each do |e|
        if e == @titre_d
          @lien_d = data[i+1]
        end
        i = i + 1
      end
      data.delete(@titre_d)
      data.delete(@lien_d)
      data = data * ";"
      file = File.open("public/folders/#{current_user.nom}/#{params[:draw]}/#{params[:folder]}/videos.txt", "w")
        file.write(data)
      file.close
      redirect_to :back
    end
  end

#==============================================================
#                     PRIVATE
#==============================================================

  private

  def ccid(cpte)
    nomcompte = cpte.to_s.gsub(/\s+|'/, '_')
    currentcompte = Compte.where(:nom => nomcompte).take
    ccid = currentcompte.id
  end

  def eleve_params
      params.require(:eleve).permit(:identifiant_eleve, :password, :is_admin)
  end

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:nom, :email, :password, :is_admin) }
  end

  def draw_auth(desk)
    auth = false
    @elev = User.where(nom: current_user.nom).where.not(identifiant_eleve: nil).all
    acces = desk.publish
    @elev.each_with_index do |el, i|
      if el.id == current_user.id && acces[i].to_i == 1
        auth = true
      end
    end
    return auth
  end

end
