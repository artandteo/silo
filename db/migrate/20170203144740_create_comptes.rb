class CreateComptes < ActiveRecord::Migration[5.0]
  def change
    create_table :comptes do |t|
      t.string :nom
    end
  end
end
