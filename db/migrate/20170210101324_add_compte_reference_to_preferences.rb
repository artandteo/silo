class AddCompteReferenceToPreferences < ActiveRecord::Migration[5.0]
  def change
    add_reference :preferences, :compte, foreign_key: true
  end
end
