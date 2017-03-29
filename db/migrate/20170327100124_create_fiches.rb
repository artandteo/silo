class CreateFiches < ActiveRecord::Migration[5.0]
  def change
    create_table :fiches do |t|
      t.string :name
      t.string :route
      t.string :type
      t.boolean :publish

      t.timestamps
    end
  end
end
