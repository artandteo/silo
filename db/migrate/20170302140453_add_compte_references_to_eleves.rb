class AddCompteReferencesToEleves < ActiveRecord::Migration[5.0]
  def change
    add_reference :eleves, :compte, foreign_key: true
  end
end
