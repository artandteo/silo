class RegistrationsController < Devise::RegistrationsController
  def create
    if params.include?(:user) 
    	if !User.exists?(email: params[:user][:email]) || !User.exists?(nom: params[:user][:nom].to_s.gsub(/\s+/, '_'))
    		params[:user][:nom] = params[:user][:nom].to_s.gsub(/\s+/, '_')
    		super
    	else 
    		flash[:danger] = "Le nom ou l'email existe déjà !"
    		redirect_to :back
    	end
        	
    end
  end
end