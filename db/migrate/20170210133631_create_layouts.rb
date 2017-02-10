class CreateLayouts < ActiveRecord::Migration[5.0]
  def change
    create_table :layouts do |t|
    	t.string :ref
      t.string :margin
      t.string :minwidth
      t.string :radius
    end
  end
end
