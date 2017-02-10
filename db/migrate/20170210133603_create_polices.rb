class CreatePolices < ActiveRecord::Migration[5.0]
  def change
    create_table :polices do |t|
      t.string :ref
      t.string :nom
    end
  end
end
