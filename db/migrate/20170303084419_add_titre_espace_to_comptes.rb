class AddTitreEspaceToComptes < ActiveRecord::Migration[5.0]
  def change
    add_column :comptes, :titre_espace, :string, default: "Mon Silo"
  end
end
