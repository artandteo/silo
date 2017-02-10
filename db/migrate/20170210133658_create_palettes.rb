class CreatePalettes < ActiveRecord::Migration[5.0]
  def change
    create_table :palettes do |t|
    	t.string :ref
      t.string :c1
      t.string :c2
      t.string :c3
      t.string :c4
      t.string :c5
    end
  end
end
