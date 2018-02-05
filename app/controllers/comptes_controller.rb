class ComptesController < ApplicationController

  before_action :set_compte, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def index
    @comptes = Compte.where(:user_id => current_user.id).all
  end

  def show
  end

  def new
    if current_user.is_admin != 1
      return head :forbidden
    end
    @compte = Compte.new
  end

  def edit
    @cpte = Compte.find(params[:id])
    @user = User.find(current_user.id)
    @user.update_without_password(:nom => @cpte.nom)
    redirect_to root_path
  end

  def create
    params[:compte][:nom] = params[:compte][:nom].to_s.gsub(/\s+/, '_')
    @compte = Compte.new(compte_params)
    if !Dir.exists?(File.join("./public/folders/", params[:compte][:nom].to_s.gsub(/\s+/, '_')))
      Dir.mkdir(File.join("./public/folders/", params[:compte][:nom].to_s.gsub(/\s+/, '_')), 0777)
    else
     flash[:error] = 'Désolé ce nom de Silo existe déjà.'
     # redirect_to new_compte_path, notice: "Désolé ce nom de compte Silo existe déjà"
    end

    respond_to do |format|
      if @compte.save
        @preference = Preference.new(:polices => "1", :img_header => "", :color1 => "FF5B2B", :color2 => "B1221C", :color3 => "34393E", :color4 => "8CC6D7", :color5 => "FFDA8C",  :layout => "1", :compte_id => @compte.id)
        @preference.save
        @user = User.find(current_user.id)
        @user.update_without_password(:nom => @compte.nom)
        puts @user.errors.full_messages
        format.html { redirect_to @compte, notice: 'Nouveau Silo créé.' }
        format.json { render :show, status: :created, location: @compte }
      else
        format.html { render :new }
        format.json { render json: @compte.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

  end

  def destroy
    @cptes = Compte.where(user_id: current_user.id).all
    if @cptes.count > 1
      flash[:alert] = 'Il doit vous rester au moins 1 compte !'
      if Dir.exists?("./public/folders/#{@compte.nom}")
        FileUtils.rm_rf("./public/folders/#{@compte.nom}")
        @compte.destroy
        @cpte = Compte.where(user_id: current_user.id).last
        @user = User.find(current_user.id)
        @user.update_without_password(:nom => @cpte.nom)
        @utilisat = User.where(nom: @compte.nom).all
        @utilisat.each do |u|
          u.destroy
        end
        flash[:alert] = 'Le compte a bien été supprimé.'
      else
        flash[:alert] = 'Le dossier n\'existe pas !'
      end
    else
      flash[:alert] = 'Il doit vous rester au moins 1 compte !'
    end
      redirect_to comptes_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:id, :email, :created_at, :updated_at, :nom, :identifiant_eleve, :is_admin])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_compte
      @compte = Compte.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def compte_params
      params.require(:compte).permit(:nom, :user_id, :titre_espace)
    end

    def user_params
      params.require(:user).permit(:id, :email, :created_at, :updated_at, :nom, :identifiant_eleve, :is_admin)
    end


end