class RenameDebtorToCharge < ActiveRecord::Migration[6.0]
  def change
    rename_table :debtors, :charges
  end
end
