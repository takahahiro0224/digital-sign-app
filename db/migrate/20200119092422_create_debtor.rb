class CreateDebtor < ActiveRecord::Migration[6.0]
  def change
    create_table :debtors do |t|
      t.belongs_to :bill
      t.integer :friend_id

      t.timestamps null: false
    end
  end
end
