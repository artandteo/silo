class Compte < ApplicationRecord
	has_many :user
	has_many :preference, :dependent => :destroy
	has_many :desk, :dependent => :destroy

end
