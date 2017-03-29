class AddCompteIdToDesk < ActiveRecord::Migration[5.0]
  def change
    add_reference :desks, :compte, foreign_key: true
  end
end
