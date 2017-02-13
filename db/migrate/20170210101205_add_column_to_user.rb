class AddColumnToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :nom, :string
    add_column :users, :identifiant_eleve, :string
    add_index  :users, :identifiant_eleve,   unique: true
  end

end
