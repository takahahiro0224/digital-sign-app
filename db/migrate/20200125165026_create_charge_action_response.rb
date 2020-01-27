class CreateChargeActionResponse < ActiveRecord::Migration[6.0]
  def change
    create_table :charge_action_responses do |t|
      t.belongs_to :charge_action
      t.integer :payment_ability, null: false, default: 0
      t.text :comment

      t.timestamps null: false
    end
  end
end
