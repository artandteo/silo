class RenameColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :fiches, :type, :genre
  end
end
