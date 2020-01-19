class AddColumnBills < ActiveRecord::Migration[6.0]
  def change
    add_column :bills, :payment_due_date, :date
  end
end
