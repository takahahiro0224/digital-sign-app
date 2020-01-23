class AddColumnToBills < ActiveRecord::Migration[6.0]
  def change
    add_column :bills, :category, :integer, null: false, default: 0
    remove_column :bills, :title, :string
  end
end
