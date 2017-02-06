class AddComptesReferencesToPreferences < ActiveRecord::Migration[5.0]
  def change
    add_reference :preferences, :comptes, foreign_key: true
  end
end
