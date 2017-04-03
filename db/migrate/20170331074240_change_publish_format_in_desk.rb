class ChangePublishFormatInDesk < ActiveRecord::Migration[5.0]
  def change
    change_column :desks, :publish, :integer
    change_column :draws, :publish, :integer
    change_column :fiches, :publish, :integer
  end
end
