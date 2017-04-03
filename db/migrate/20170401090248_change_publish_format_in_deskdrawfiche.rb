class ChangePublishFormatInDeskdrawfiche < ActiveRecord::Migration[5.0]
  def change
    change_column :desks, :publish, :string
    change_column :draws, :publish, :string
    change_column :fiches, :publish, :string
  end
end
