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
      redirect_to desk_path(current_user.name)
    end
  end

  def desk

    @prefs = Preference.where(comptes_id: current_user.id)
    
    if params[:desk] == current_user.name
      liste_d("./public/folders/#{current_user.name}/")
    else
      redirect_to desk_path(current_user.name)
    end
  end

  def draw
      @table = Array.new { Array.new }
      i = 0
      liste_d("./public/folders/#{current_user.name}/#{params[:draw]}/").each do |a|

        b = liste_f("./public/folders/#{current_user.name}/#{params[:draw]}/#{a}/")
        @table.push(b)
        @length = @table.length
      i = i + 1
      end

      liste_d("./public/folders/#{current_user.name}/#{params[:draw]}/")
      liste_f("./public/folders/#{current_user.name}/#{params[:draw]}/")
  end

  def draw_add
    if params.include?(:nouv_dossier)
      path = "./public/folders/#{params[:desk]}/#{params[:draw]}/"
      Dir.mkdir(File.join(path, params[:nouv_dossier][:nom]), 0777)
      redirect_to draw_path(current_user.name)
    else
      authorized_ext = [".pdf", ".jpg", ".jpeg"]
      if !params[:nouv_fichier][:fichier].blank?
        filename = params[:nouv_fichier][:fichier].original_filename
        directory = "public/folders/#{current_user.name}/#{params[:draw]}/#{params[:nouv_fichier][:dossier_courant]}/"
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

  def desk_add
    if params.include?(:nouv_desk)
      path = "./public/folders/#{params[:desk]}/"
      Dir.mkdir(File.join(path, params[:nouv_desk][:nom]), 0777)
      redirect_to desk_path
    end
  end

  def desk_rename
    FileUtils.mv("./public/folders/#{current_user.name}/#{params[:rename][:last_name]}", "./public/folders/#{current_user.name}/#{params[:rename][:new_name]}")
    redirect_to desk_path
  end

  def desk_delete
    FileUtils.rm_rf("./public/folders/#{params[:desk]}/#{params[:draw]}/#{params[:dossier]}")
    redirect_to desk_path
  end

  def draw_rename
    FileUtils.mv("./public/folders/#{current_user.name}/#{params[:draw]}/#{params[:rename][:last_name]}", "./public/folders/#{current_user.name}/#{params[:draw]}/#{params[:rename][:new_name]}")
    redirect_to desk_path
  end


  private

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
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
    puts dir
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
