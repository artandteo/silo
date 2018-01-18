class AddRangToDraws < ActiveRecord::Migration[5.0]
  def change
    add_column :draws, :rang, :integer
  end
end
