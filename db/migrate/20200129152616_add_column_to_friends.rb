class AddColumnToFriends < ActiveRecord::Migration[6.0]
  def change
    add_column :friends, :credit_score, :integer, default: 100
  end
end
