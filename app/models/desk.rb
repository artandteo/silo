class Desk < ApplicationRecord
  belongs_to :compte
  has_many :draw
end
