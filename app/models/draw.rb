class Draw < ApplicationRecord
  belongs_to :desk
  has_many :fiche, :dependent => :destroy
end
