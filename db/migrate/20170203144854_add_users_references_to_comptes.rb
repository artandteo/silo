class AddUsersReferencesToComptes < ActiveRecord::Migration[5.0]
  def change
    add_reference :comptes, :users, foreign_key: true
  end
end
