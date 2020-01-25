class ChargeAction < ApplicationRecord
  belongs_to :charge
  has_one :charge_action
  enum action_type: { notice: 0, remind: 1, alert: 2 }
end
