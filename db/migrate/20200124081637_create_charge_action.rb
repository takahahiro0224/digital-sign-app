class CreateChargeAction < ActiveRecord::Migration[6.0]
  def change
    create_table :charge_actions do |t|
      t.belongs_to :charge
      t.integer :type, null: false, default: 0

      t.timestamps null: false
    end
  end
end
