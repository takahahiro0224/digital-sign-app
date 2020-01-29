class AddPaidAtToCharges < ActiveRecord::Migration[6.0]
  def change
    add_column :charges, :paid_at, :datetime
  end
end
