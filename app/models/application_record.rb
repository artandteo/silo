class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
 
  #validates :fichier, presence: true

end
