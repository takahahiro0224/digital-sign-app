class AddAutoMailToBills < ActiveRecord::Migration[6.0]
  def change
    add_column :bills, :auto_mail, :boolean, null: false, default: false
  end
end
