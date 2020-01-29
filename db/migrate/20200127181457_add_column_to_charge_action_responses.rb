class AddColumnToChargeActionResponses < ActiveRecord::Migration[6.0]
  def change
    add_column :charge_action_responses, :comment_score, :float

    add_column :charge_action_responses, :comment_magnitude, :float
  end
end
