class AddRangToDesks < ActiveRecord::Migration[5.0]
  def change
    add_column :desks, :rang, :integer
  end
end
