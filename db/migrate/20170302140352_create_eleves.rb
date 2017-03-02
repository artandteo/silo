class CreateEleves < ActiveRecord::Migration[5.0]
  def change
    create_table :eleves do |t|
      t.string :identifiant
      t.string :password
    end
  end
end
