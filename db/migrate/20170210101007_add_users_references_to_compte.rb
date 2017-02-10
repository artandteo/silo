class AddUsersReferencesToCompte < ActiveRecord::Migration[5.0]
  def change
    add_reference :comptes, :user, foreign_key: true
  end
end
