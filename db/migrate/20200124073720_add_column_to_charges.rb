class AddColumnToCharges < ActiveRecord::Migration[6.0]
  def change
    remove_column :charges, :friend_id, :integer

    add_reference :charges, :friend, foreign_key: true

    add_column :charges, :paid, :boolean, default: false, null: false
  end
end
