class CreatePreferences < ActiveRecord::Migration[5.0]
  def change
    create_table :preferences do |t|
      t.string :polices
      t.string :img_header
      t.string :color1
      t.string :color2
      t.string :color3
      t.string :color4
      t.string :color5
      t.string :color6
    end
  end
end
