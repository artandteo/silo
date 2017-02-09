class Preference < ApplicationRecord
	has_many :user
	has_one :compte
	
end