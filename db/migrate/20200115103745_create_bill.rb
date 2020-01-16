class CreateBill < ActiveRecord::Migration[6.0]
  def change
    create_table :bills do |t|
      t.string :title
      t.text: :description
      t.integer :price_cents 
      t.string :currency, default: "JPY"
      t.boolean :paid 
    end
  end
end
