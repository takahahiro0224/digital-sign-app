class ChargeActionResponse < ApplicationRecord
  belongs_to :charge_action
  enum payment_ability: { fine: 0, late: 1, unknown: 2 }
end
