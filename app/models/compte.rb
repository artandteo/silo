class Compte < ApplicationRecord
	has_many :user
	has_many :preference
end