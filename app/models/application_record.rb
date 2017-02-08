class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
	mount_uploader :fichier, FichiersUploader

  	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable


end
