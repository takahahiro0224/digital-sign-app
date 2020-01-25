class RenameTypeColumnToChargeActions < ActiveRecord::Migration[6.0]
  def change
    rename_column :charge_actions, :type, :action_type
  end
end
