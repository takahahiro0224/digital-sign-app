class CreateBill < ActiveRecord::Migration[6.0]
  def change
    create_table :bills do |t|
      t.belongs_to :user
      t.string :title, null: false
      t.text :description
      t.integer :price_cents, null: false, default: 0
      t.string :currency, null: false, default: "JPY"
      t.boolean :paid, null: false, default: false
    end
  end
end
