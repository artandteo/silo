class CreateDraws < ActiveRecord::Migration[5.0]
  def change
    create_table :draws do |t|
      t.string :name, limit: 25
      t.string :route, limit: 25
      t.boolean :publish

      t.timestamps
    end
  end
end
