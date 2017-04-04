class Desk < ApplicationRecord
  belongs_to :compte
  has_many :draw, :dependent => :destroy
end
