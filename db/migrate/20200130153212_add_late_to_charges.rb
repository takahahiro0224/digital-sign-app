class AddLateToCharges < ActiveRecord::Migration[6.0]
  def change
    add_column :charges, :late, :boolean, default: false
  end
end
