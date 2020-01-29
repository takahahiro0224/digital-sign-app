class AddTokenToChargeActions < ActiveRecord::Migration[6.0]
  def change
    add_column :charge_actions, :token, :string, null: false
  end
end
