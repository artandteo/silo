class AddTitreEspaceToComptes < ActiveRecord::Migration[5.0]
  def change
    add_column :comptes, :titre_espace, :string
  end
end
