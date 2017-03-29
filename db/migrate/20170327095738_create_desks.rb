class CreateDesks < ActiveRecord::Migration[5.0]
  def change
    create_table :desks do |t|
      t.string :name, limit: 20
      t.string :route, limit: 20
      t.boolean :publish

      t.timestamps
    end
  end
end
