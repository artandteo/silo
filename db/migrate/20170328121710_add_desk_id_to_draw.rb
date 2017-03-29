class AddDeskIdToDraw < ActiveRecord::Migration[5.0]
  def change
    add_reference :draws, :desk, foreign_key: true
  end
end
