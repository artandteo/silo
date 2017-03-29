class AddDrawIdToFiche < ActiveRecord::Migration[5.0]
  def change
    add_reference :fiches, :draw, foreign_key: true
  end
end
