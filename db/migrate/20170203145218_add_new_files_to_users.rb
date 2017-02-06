class AddNewFilesToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :name, :string, null: false, default: ""
  	add_column :users, :identifiant, :string
  	add_column :users, :visites, :integer

  	add_index :users, :name,	unique: true
  	add_index :users, :identifiant,	unique: true
  end
  
end
