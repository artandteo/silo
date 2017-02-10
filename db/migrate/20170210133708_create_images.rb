class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
    	t.string :ref
      t.string :nom
    end
  end
end
